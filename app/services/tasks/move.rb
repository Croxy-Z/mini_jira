# frozen_string_literal: true

module Tasks
  class Move
    Result = Struct.new(:success?, :task, :error, keyword_init: true)

    def self.call(task:, new_status:)
      new(task:, new_status:).call
    end

    def initialize(task:, new_status:)
      @task = task
      @new_status = new_status.to_s
    end

    def call
      return failure(:invalid_status) unless valid_status?

      task.status = new_status

      Result.new(
        success?: task.save,
        task:,
        error: task.errors.full_messages.presence
      )
    end

    private

    attr_reader :task, :new_status

    def valid_status?
      Task.statuses.key?(new_status)
    end

    def failure(error)
      Result.new(success?: false, task:, error:)
    end
  end
end
