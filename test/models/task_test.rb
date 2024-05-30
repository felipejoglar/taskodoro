require "test_helper"

class TaskTest < ActiveSupport::TestCase

  test "task attributes must not be empty" do
    task = Task.create

    assert task.invalid?, message: "Task without params should be invalid"
    assert task.errors[:title].any?, message: "Expected name to be present"
    assert task.errors[:user_id].any?, message: "Expected task to belong to an user"
    assert task.errors[:project_id].any?, message: "Expected task to belong to a project"
  end

  test "task sets default values" do
    Current.user = users(:felipe)
    task = Task.create

    assert_equal Current.user, task.user, message: "Expected user default value to be Current.user"
    assert_equal false, task.completed, message: "Expected completed default value to be false"
    assert_equal Date.today, task.due_date, message: "Expected due_date default value to be today"
  end

  test "task's empty description is saved as nil" do
    task = Task.new(description: "")

    assert_nil task.description
  end
end
