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

  test "user email should be valid" do
    validEmails = %w{ valid@email.com another-valid@email.org yet.another.valid@email.io }

    validEmails.each do |email|
      assert valid_user(email: email).valid?, message: "#{email} should be a valid email"
    end

    validEmails = %w{ in"valid"@email.com a@b@c@email.com in\valid@email.com }

    validEmails.each do |email|
      assert valid_user(email: email).invalid?, message: "#{email} should not be a valid email"
    end
  end

  private

  def valid_user(name: "A Name", email: "valid@email.com", password: "password")
    User.new(
      name: name,
      email: email,
      password: password,
    )
  end
end
