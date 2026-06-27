# frozen_string_literal: true

module Tasks
  class Create
    Result = Struct.new(:success?, :task, keyword_init: true)

    def self.call(task:)
      new(task:).call
    end

    def initialize(task:)
      @task = task
    end

    def call
      @task.save

      Result.new(success?: @task.persisted?, task: @task)
    end
  end
end
