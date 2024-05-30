require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = sign_in_as(name: "Test User", email: "test@taskodoro.com", password: "a_valid_password")
    @project = @user.projects.all.first
    @task = Task.create(title: "A task", project: @project, user: @user)
  end

  test "showing a project" do
    get project_task_url(@user, @project, @task)

    assert_response :ok
    assert_select "h1", @task.title
    assert_select "p", "Description: #{@task.description || "No description provided"}"
  end

  test "creating a new task" do
    get new_project_task_url(@user, @project)

    assert_response :ok
    assert_select "h1", "Create New Task"

    assert_difference "Task.count", 1 do
      post project_tasks_url, params: task_params(title: "New Task", description: "This is a new task")
    end

    assert_redirected_to project_url(@user, @project)
    follow_redirect!

    assert_response :ok
    assert_select "h1", @project.title
    assert_select "a", Task.last.title
    assert_select "p", Task.last.description
  end

  test "updating a task" do
    get edit_project_task_url(@user, @project, @task)

    assert_response :ok
    assert_select "h1", "Edit Task"

    patch project_task_url(@user, @project, @task), params: task_params(title: "Updated Title", description: "Updated Description")

    assert_redirected_to project_task_url(@user, @project, @task)
    follow_redirect!

    assert_response :ok
    assert_select "h1", "Updated Title"
    assert_select "p", "Description: Updated Description"
  end

  test "deleting a task" do

    assert_difference "Task.count", -1 do
      delete project_task_url(@user, @project, @task)
    end

    assert_redirected_to project_url(@user, @project)
    follow_redirect!

    assert_response :ok
    assert_select "h1", @project.title
    assert_select "a", { count: 0, text: @task.title }
  end

  private

  def task_params(title:, description:)
    { task: { title: title, description: description } }
  end
end