# frozen_string_literal: true

module Tasks
  class Move
    Result = Struct.new(:success?, :task, :error_code, :errors, keyword_init: true)

    def self.call(task:, new_status:)
      new(task:, new_status:).call
    end

    def initialize(task:, new_status:)
      @task = task
      @new_status = new_status.to_s
    end

    def call
      return failure(error_code: :invalid_status) unless valid_status?

      task.status = new_status

      return success if task.save

      failure(error_code: :validation_failed, errors: task.errors.full_messages)
    end

    private

    attr_reader :task, :new_status

    def valid_status?
      Task.statuses.key?(new_status)
    end

    def success
      Result.new(success?: true, task:, error_code: nil, errors: [])
    end

    def failure(error_code:, errors: [])
      Result.new(success?: false, task:, error_code:, errors:)
    end
  end
end
