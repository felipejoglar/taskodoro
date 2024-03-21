class ProjectsController < ApplicationController
  def index
    @projects = Current.user.projects.all
  end
end
