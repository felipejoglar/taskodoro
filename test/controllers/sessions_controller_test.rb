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

class SessionsControllerTest < ActionDispatch::IntegrationTest

  test "creating a new session" do
    email = "felipe@taskodoro.com"
    password = "a_valid_password"

    get signin_url

    assert_response :ok
    assert_select 'h2', I18n.t("auth.sign_in.title")

    create_user_with(email: email, password: password)

    post signin_url, params: login_params(email: email, password: password)
    assert session["current_user_id"], "User should be logged in after creation"

    follow_redirect!
    assert_response :ok
    assert_select 'h1', 'Welcome Felipe'
  end

  test "failing to create a new session" do
    email = "felipe@taskodoro.com"
    password = "a_valid_password"

    get signin_url

    assert_response :ok
    assert_select 'h2', I18n.t("auth.sign_in.title")

    create_user_with(email: email, password: password)

    post signin_url, params: login_params(email: "not_signed_up@email.com", password: password)
    assert_response :unprocessable_entity

    assert_select 'div.alert', 1
  end

  test "destroy current session" do
    email = "felipe@taskodoro.com"
    password = "a_valid_password"

    create_user_with(email: email, password: password)
    post signin_url, params: login_params(email: email, password: password)
    assert session["current_user_id"], "User should be logged in after creation"
    follow_redirect!

    delete signout_url
    refute session["current_user_id"]

    follow_redirect!
    assert_select 'h1', I18n.t("landing.welcome")
  end

  private

  def create_user_with(email:, password:)
    User.create!(
      name: "Felipe",
      email: email,
      password: password,
      password_confirmation: password
    )
  end

  def login_params(email:, password:)
    {
      user:
        {
          email: email,
          password: password
        }
    }
  end
end
