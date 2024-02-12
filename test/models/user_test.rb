require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user attributes must not be empty" do
    user = User.new
    assert user.invalid?, message: "User without params should be invalid"
    assert user.errors[:name].any?, message: "Expected name to be present"
    assert user.errors[:email].any?, message: "Expected email to be present"
    assert user.errors[:password].any?, message: "Expected password to be present"
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

  test "user password should be long enough" do
    invalid_password = "a" * (MIN_PASSWORD_LENGTH - 1)
    assert valid_user(password: invalid_password).invalid?, message: "A password with #{invalid_password.length} characters should not be valid"
    invalid_password = "a" * (MAX_PASSWORD_LENGTH + 1)
    assert valid_user(password: invalid_password).invalid?, message: "A password with #{invalid_password.length} characters should not be valid"

    valid_password = "a" * MIN_PASSWORD_LENGTH
    assert valid_user(password: valid_password).valid?, message: "'A password with #{invalid_password.length} characters should be valid"
    valid_password = "a" * MAX_PASSWORD_LENGTH
    assert valid_user(password: valid_password).valid?, message: "'A password with #{invalid_password.length} characters should be valid"
  end

  private

  MIN_PASSWORD_LENGTH = 12
  MAX_PASSWORD_LENGTH = 64

  def valid_user(name: "A Name", email: "valid@email.com", password: "a_long_enough_password")
    User.new(
      name: name,
      email: email,
      password: password,
    )
  end
end
