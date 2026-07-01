# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    @projects = policy_scope(Project).order(created_at: :desc)
    @recent_projects = @projects.limit(3)

    @tasks = policy_scope(Task)
    @projects_count = @projects.count
    @tasks_count = @tasks.count
    @done_tasks_count = @tasks.done.count
  end
end
