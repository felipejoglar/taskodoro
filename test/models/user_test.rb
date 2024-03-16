#    Copyright 2024 Felipe Joglar
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

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
    valid_emails = %w{ valid@email.com another-valid@email.org yet.another.valid@email.io }

    valid_emails.each do |email|
      assert valid_user(email: email).valid?, message: "#{email} should be a valid email"
    end

    valid_emails = %w{ in"valid"@email.com a@b@c@email.com in\valid@email.com }

    valid_emails.each do |email|
      assert valid_user(email: email).invalid?, message: "#{email} should not be a valid email"
    end
  end

  test "user password should be long enough" do
    invalid_password = "a" * (MIN_PASSWORD_LENGTH - 1)
    assert_not valid_user(password: invalid_password).valid?, message: "A password with #{invalid_password.length} characters should not be valid"
    invalid_password = "a" * (MAX_PASSWORD_LENGTH + 1)
    assert_not valid_user(password: invalid_password).valid?, message: "A password with #{invalid_password.length} characters should not be valid"

    valid_password = "a" * MIN_PASSWORD_LENGTH
    assert valid_user(password: valid_password).valid?, message: "'A password with #{invalid_password.length} characters should be valid"
    valid_password = "a" * MAX_PASSWORD_LENGTH
    assert valid_user(password: valid_password).valid?, message: "'A password with #{invalid_password.length} characters should be valid"
  end

  test "user email should be unique" do
    unique_email = "a_unique@email.com"
    user = valid_user(email: unique_email)
    duplicated_user = user.dup

    user.save

    assert_not duplicated_user.valid?, message: "Users with duplicated emails should not be valid"
  end

  test "user email should be normalized to lowercase and trimmed" do
    email = "  An_EmaIL@emAiL.cOm   "
    user = valid_user(email: email)

    assert_equal("an_email@email.com", user.email)
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
