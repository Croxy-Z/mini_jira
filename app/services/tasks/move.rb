# frozen_string_literal: true

module Tasks
  class Move
    Result = Struct.new(:success?, :task, :error_code, :errors, keyword_init: true)

    def self.call(task:, actor:, new_status:)
      new(task:, actor:, new_status:).call
    end

    def initialize(task:, actor:, new_status:)
      @task = task
      @actor = actor
      @new_status = new_status.to_s
    end

    def call
      return failure(error_code: :invalid_status) unless valid_status?

      from_status = task.status
      return success if from_status == new_status

      ActiveRecord::Base.transaction do
        task.update!(status: new_status)
        record_activity(from_status:)
      end

      success
    rescue ActiveRecord::RecordInvalid => e
      failure(error_code: :record_invalid, errors: e.record.errors.full_messages)
    end

    private

    attr_reader :task, :actor, :new_status

    def valid_status?
      Task.statuses.key?(new_status)
    end

    def success
      Result.new(success?: true, task:, error_code: nil, errors: [])
    end

    def failure(error_code:, errors: [])
      Result.new(success?: false, task:, error_code:, errors:)
    end

    def record_activity(from_status:)
      task.task_activities.create!(
        user: actor,
        project: task.project,
        action: TaskActivity::ACTION_MOVED,
        from_status:,
        to_status: new_status
      )
    end
  end
end
