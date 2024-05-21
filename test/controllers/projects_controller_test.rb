require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = sign_in_as(name: "Test User", email: "test@taskodoro.com", password: "a_valid_password")
    @projects = @user.projects.all
  end

  test "getting the list of projects" do
    get projects_url(@user)

    assert_response :ok
    assert_select "h1", "#{@user.name}'s Projects"
  end

  test "showing a project" do
    project = @projects.first

    get project_url(@user, project)

    assert_response :ok
    assert_select "h1", project.title
    assert_select "p", "Description: #{project.description || "No description provided"}"
  end

  test "creating a new project" do
    get new_project_url(@user)

    assert_response :ok
    assert_select "h1", "Create New Project"

    assert_difference "Project.count", 1 do
      post projects_url, params: project_params(title: "New Project", description: "This is a new project")
    end

    assert_redirected_to project_path(@user, Project.last)
    follow_redirect!

    assert_response :ok
    assert_select "h1", Project.last.title
    assert_select "p", "Description: #{Project.last.description || "No description provided"}"
  end

  test "updating a project" do
    project = @projects.last

    get edit_project_url(@user, project)

    assert_response :ok
    assert_select "h1", "Edit Project"

    patch project_path(@user, project), params: project_params(title: "Updated Title", description: "Updated Description")

    assert_redirected_to project_url(@user, project)
    follow_redirect!

    assert_response :ok
    assert_select "h1", "Updated Title"
    assert_select "p", "Description: Updated Description"
  end

  test "deleting a project" do

    assert_difference "Project.count", -1 do
      delete project_url(@user, @projects.last)
    end

    assert_redirected_to projects_url(@user)
    follow_redirect!

    assert_response :ok
    assert_select "h1", "#{@user.name}'s Projects"
  end

  private

  def project_params(title:, description:)
    { project: { title: title, description: description } }
  end
end