# frozen_string_literal: true

class TaskColumnComponent < ViewComponent::Base
  TITLE_CLASSES = {
    "to_do" => "text-gray-700",
    "in_progress" => "text-blue-600",
    "done" => "text-green-600"
  }.freeze

  COUNTER_CLASSES = {
    "to_do" => "bg-gray-200 text-gray-700",
    "in_progress" => "bg-blue-100 text-blue-700",
    "done" => "bg-green-100 text-green-700"
  }.freeze

  def initialize(title:, status:, tasks:, project:)
    super()
    @title = title
    @status = status
    @tasks = tasks
    @project = project
  end

  private

  attr_reader :title, :status, :tasks, :project

  def column_id
    "tasks_#{status}"
  end

  def counter_id
    "#{column_id}_count"
  end

  def empty_state_id
    "#{column_id}_empty_state"
  end

  def title_class
    TITLE_CLASSES.fetch(status)
  end

  def counter_class
    COUNTER_CLASSES.fetch(status)
  end
end
