# frozen_string_literal: true

module Projects
  class Create
    Result = Struct.new(:success?, :project, keyword_init: true)

    def self.call(user:, params:)
      new(user:, params:).call
    end

    def initialize(user:, params:)
      @user = user
      @params = params
    end

    def call
      project = @user.projects.build(@params)

      project.save

      Result.new(success?: project.persisted?, project:)
    end
  end
end
