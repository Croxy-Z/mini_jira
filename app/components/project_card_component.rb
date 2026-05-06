# frozen_string_literal: true

class ProjectCardComponent < ViewComponent::Base
  def initialize(project:)
    super()
    @project = project
  end

  def created_date
    "#{time_ago_in_words(@project.created_at)} ago"
  end
end
