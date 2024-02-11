require "test_helper"

class UserTest < ActiveSupport::TestCase

  test "user attributes must not be empty" do
    user = User.new
    assert user.invalid?, message: "User without params should be invalid"
    assert user.errors[:name].any?, message: "Expected name to be present"
    assert user.errors[:email].any?, message: "Expected email to be present"
    assert user.errors[:password].any?, message: "Expected password to be present"
    p user.errors
  end
end
