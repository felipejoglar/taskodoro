require "test_helper"

class ProjectTest < ActiveSupport::TestCase

  test "project attributes must not be empty" do
    project = Project.new

    assert project.invalid?, message: "Project without params should be invalid"
    assert project.errors[:title].any?, message: "Expected name to be present"
    assert project.errors[:user_id].any?, message: "Expected project to belong to an user"
  end

  test "project's empty description is saved as nil" do
    project = Project.new(description: "")

    assert_nil project.description
  end

  test "project's tasks are queried ordered by due_date" do
    first_task = task_with_due_date(tasks(:one), Date.today)
    last_task = task_with_due_date(tasks(:two), Date.today.next_day(10))

    tasks = projects(:inbox).tasks

    assert_equal first_task, tasks.first
    assert_equal last_task, tasks.last
  end

  test "destroying a project destroys its tasks" do
    Current.user = users(:felipe)
    project = users(:felipe).projects.create(title: "A Project")
    task = project.tasks.create(title: "A Task")

    project.destroy!

    refute Project.find_by(id: project.id)
    refute Task.find_by(id: task.id)
  end

  private

  def task_with_due_date(task, due_date)
    task.due_date = due_date
    task.save

    task
  end
end
