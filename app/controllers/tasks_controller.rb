# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, only: %i[show edit update destroy move]

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

    result = Tasks::Create.call(task: @task)

    if result.success?
      respond_to do |format|
        format.html { redirect_to project_path(@project), notice: t(".success") }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    authorize @task

    if @task.update(task_update_params)
      redirect_to project_path(@project), notice: t(".success")
    else
      render :edit, status: :unprocessable_content
    end
  end

  def move
    authorize @task

    result = Tasks::Move.call(task: @task, new_status: task_move_params[:status])

    if result.success?
      render json: { status: result.task.status }, status: :ok
    else
      render json: { error: result.error }, status: :unprocessable_content
    end
  end

  def destroy
    authorize @task

    @task.destroy
    redirect_to project_path(@project), notice: t(".success")
  end

  private

  def set_project
    @project = policy_scope(Project).find(params.expect(:project_id))
  end

  def set_task
    @task = @project.tasks.find(params.expect(:id))
  end

  def task_params
    params.expect(task: %i[title description])
  end

  def task_update_params
    params.expect(task: %i[title description status])
  end

  def task_move_params
    params.expect(task: %i[status])
  end
end
