# frozen_string_literal: true

module Projects
  class Create
    Result = Struct.new(:success?, :project, keyword_init: true)

    def self.call(project:)
      new(project:).call
    end

    def initialize(project:)
      @project = project
    end

    def call
      @project.save

      Result.new(success?: @project.persisted?, project: @project)
    end
  end
end
