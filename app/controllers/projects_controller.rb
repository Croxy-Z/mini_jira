# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  def index
    @projects = policy_scope(Project)
    authorize Project
  end

  def show
    authorize @project

    @tasks_by_status = @project.tasks.order(:created_at).group_by(&:status)
  end

  def new
    @project = current_user.projects.build
    authorize @project
  end

  def edit
    authorize @project
  end

  def create
    @project = current_user.projects.build(project_params)
    authorize @project

    result = Projects::Create.call(project: @project)

    if result.success?
      redirect_to @project, notice: t(".success")
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    authorize @project

    if @project.update(project_params)
      redirect_to @project, notice: t(".success")
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize @project
    @project.destroy

    redirect_to projects_path, notice: t(".success")
  end

  private

  def set_project
    @project = policy_scope(Project).find(params.expect(:id))
  end

  def project_params
    params.expect(project: %i[title description])
  end
end
