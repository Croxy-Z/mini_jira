# frozen_string_literal: true

module Tasks
  class Create
    Result = Struct.new(:success?, :task, keyword_init: true)

    def self.call(project:, params:)
      new(project:, params:).call
    end

    def initialize(project:, params:)
      @project = project
      @params = params
    end

    def call
      task = @project.tasks.build(@params)

      task.save

      Result.new(success?: task.persisted?, task:)
    end
  end
end
