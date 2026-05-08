# frozen_string_literal: true

module Projects
  class CreateService
    Result = Struct.new(:success?, :project, keyword_init: true)

    def initialize(user:, params:)
      @user = user
      @params = params
    end

    def call
      project = @user.projects.build(@params)

      project.save

      Result.new(
        success?: project.persisted?,
        project: project
      )
    end
  end
end
