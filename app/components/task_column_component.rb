# frozen_string_literal: true

class TaskColumnComponent < ViewComponent::Base
  TITLE_CLASSES = {
    "to_do" => "text-gray-700",
    "in_progress" => "text-blue-600",
    "done" => "text-green-600"
  }.freeze

  COUNTER_CLASSES = {
    "to_do" => "bg-gray-200 text-gray-700",
    "in_progress" => "bg-blue-200 text-blue-700",
    "done" => "bg-green-200 text-green-700"
  }.freeze

  COLUMN_CLASSES = {
    "to_do" => "bg-slate-50 border-slate-200",
    "in_progress" => "bg-blue-50/70 border-blue-100",
    "done" => "bg-emerald-50/70 border-emerald-100"
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

  def column_class
    COLUMN_CLASSES.fetch(status)
  end
end
