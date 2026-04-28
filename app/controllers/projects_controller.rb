# frozen_string_literal: true

class ProjectsController < ApplicationController
  # User sees only own projects, admin sees all
  def index
    @projects = current_user.admin? ? Project.all : current_user.projects
    authorize @projects
  end

  def show
    @project = Project.find(params[:id])
    authorize @project
  end

  def new
    @project = current_user.projects.build
    authorize @project
  end

  def edit
    @project = Project.find(params[:id])
    authorize @project
  end

  def create
    @project = current_user.projects.build(project_params)
    authorize @project

    if @project.save
      redirect_to @project, notice: "Project successfully created"
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    @project = Project.find(params[:id])
    authorize @project

    if @project.update(project_params)
      redirect_to @project, notice: "Project successfully updated"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @project = Project.find(params[:id])
    authorize @project
    @project.destroy

    redirect_to projects_path, notice: "Project successfully deleted"
  end

  private

  def project_params
    params.expect(project: %i[title description])
  end
end
