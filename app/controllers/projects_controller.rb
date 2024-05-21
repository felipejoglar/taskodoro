class ProjectsController < ApplicationController

  def index
    @projects = Current.user.projects.all
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    project = Current.user.projects.build(project_params)

    if project.save
      redirect_to project_path(Current.user, project)
    else
      render :new
    end
  end

  def update
    project = Project.find(params[:id])

    if project.update(project_params)
      redirect_to project_path(Current.user, project)
    else
      render :edit
    end
  end

  def destroy
    project = Project.find(params[:id])
    if project.destroy
      redirect_to projects_path(Current.user)
    else
      redirect_to project
    end
  end

  private

  def project_params
    params.require(:project).permit(:title, :description)
  end
end
