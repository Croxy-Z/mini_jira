# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, only: %i[show edit update destroy]

  def show
    authorize @task
  end

  def new
    @task = @project.tasks.build
    authorize @task
  end

  def edit
    authorize @task
  end

  def create
    @task = @project.tasks.build(task_params)
    authorize @task

    if @task.save
      redirect_to project_path(@project), notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    authorize @task

    if @task.update(task_params)
      redirect_to project_path(@project), notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize @task

    @task.destroy
    redirect_to project_path(@project), notice: "Task was successfully deleted."
  end

  private

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.expect(task: %i[title description status])
  end
end
