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
end
