class TasksController < ApplicationController
  before_action :set_project

  def new
    @task = Task.new
  end

  def create
    task = new_task

    if task.save
      redirect_to project_path(Current.user, @project)
    else
      render :new
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
    @project = Current.user.projects.find_by(id: params[:project_id])

    unless @project
      redirect_to_projects
    end
  end

  def new_task
    @project.tasks.build(task_params)
  end

  def task_params
    params.require(:task).permit(:title, :description)
  end
end
