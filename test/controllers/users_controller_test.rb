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

class UsersControllerTest < ActionDispatch::IntegrationTest

  test "creating a new user" do
    get signup_url

    assert_response :ok
    assert_select 'h2', I18n.t("auth.sign_up.title")

    post signup_url, params: valid_params(name: "Felipe")
    assert session["current_user_id"], "User should be logged in after creation"

    follow_redirect!
    assert_response :ok
    assert_select 'h1', 'Welcome Felipe'
  end

  test "failing to create a new user" do
    get signup_url

    assert_response :ok
    assert_select 'h2', I18n.t("auth.sign_up.title")

    post signup_url, params: invalid_params
    assert_response :unprocessable_entity

    assert_select 'div.alert', 1
  end

  private

  def valid_params(name:, password: "a_valid_password")
    { user:
        {
          name: name,
          email: "avalid@email",
          password: password,
          password_confirmation: password
        }
    }
  end

  def invalid_params
    { user:
        {
          name: "A name",
          email: "avalid@email",
          password: "a_valid_password",
          password_confirmation: "no_matching_password"
        }
    }
  end
end

