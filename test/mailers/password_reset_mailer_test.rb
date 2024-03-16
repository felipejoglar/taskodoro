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

class UserMailerTest < ActionMailer::TestCase

  test "password_reset sends the token in the URL" do
    email = "an_email@email.com"
    token = "a_token"

    mailer = UserMailer.with(user: user_with(email: email), token: token).password_reset

    assert_emails 1 do
      mailer.deliver_later
    end

    assert_equal [email], mailer.to
    assert_equal "Reset your password", mailer.subject
    assert mailer.body.to_s.include?("password/edit?token=#{token}")
  end

  private

  def user_with(email:)
    User.create!(name: "A Name", email: email, password: "a_valid_password")
  end
end
