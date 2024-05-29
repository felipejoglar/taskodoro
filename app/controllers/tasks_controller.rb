class TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, only: %i[ edit update destroy ]

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    task = new_task

    if task.save
      redirect_to_project
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to_project
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to_project
  end

  private

  def set_project
    @project = Current.user.projects.find_by(id: params[:project_id])

    unless @project
      redirect_to projects_path(Current.user)
    end
  end

  def set_task
    @task = @project.tasks.find_by(id: params[:id])

    unless @task
      redirect_to project_path(Current.user, @project)
    end
  end

  def new_task
    @project.tasks.build(task_params)
  end

  def redirect_to_project
    redirect_to project_path(Current.user, @project)
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :completed)
  end
end
