require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "project attributes must not be empty" do
    project = Project.new
    assert project.invalid?, message: "Project without params should be invalid"
    assert project.errors[:name].any?, message: "Expected name to be present"
  end
end
