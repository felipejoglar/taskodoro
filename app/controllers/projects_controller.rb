class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]

  def index
    @projects = Current.user.projects.all
  end

  def show
    @tasks = @project.tasks.all
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    project = Current.user.projects.build(project_params)

    if project.save
      redirect_to_project project
    else
      render :new
    end
  end

  def update
    if @project.update(project_params)
      redirect_to_project @project
    else
      render :edit
    end
  end

  def destroy
    if @project.destroy
      redirect_to_projects
    else
      redirect_to_project @project
    end
  end

  private

  def set_project
    @project = Current.user.projects.find_by(id: params[:id])

    unless @project
      redirect_to_projects
    end
  end

  def project_params
    params.require(:project).permit(:title, :description)
  end

  def redirect_to_projects
    redirect_to projects_path(Current.user)
  end

  def redirect_to_project(project)
    redirect_to project_path(Current.user, project)
  end
end
