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

class PasswordResetControllerTest < ActionDispatch::IntegrationTest
  setup do
    @name = "Felipe"
    @token = create_user_with(name: @name).generate_token_for(:password_reset)
  end

  test "requesting to create a new password" do
    get forgot_password_url

    assert_response :ok
    assert_select 'h2', I18n  .t("auth.forgot_password.title")

    post password_url, params: password_reset_params(email: "felipe@taskodoro.com")
    follow_redirect!

    assert_response :ok
    assert_select 'div.notice', I18n.t("auth.password_reset.message.confirmation")
  end

  test "updating a password" do
    get password_edit_url, params: { token: @token }

    assert_response :ok
    assert_select 'h2', I18n.t("auth.password_reset.title")

    patch "#{password_url}?token=#{@token}", params: new_password_params
    assert_response :found

    follow_redirect!
    assert_response :ok
    assert_select 'h1', "Welcome #{@name}"
  end

  test "failing to update a password with invalid token" do
    get password_edit_url, params: { token: @token }

    assert_response :ok
    assert_select 'h2', I18n.t("auth.password_reset.title")

    patch "#{password_url}?token=not_valid_token", params: new_password_params

    follow_redirect!
    assert_response :ok
    assert_equal I18n.t("auth.password_reset.message.expired"), flash[:notice]
  end

  test "failing to update a password with invalid password" do
    get password_edit_url, params: { token: @token }

    assert_response :ok
    assert_select 'h2', I18n.t("auth.password_reset.title")

    patch "#{password_url}?token=#{@token}", params: new_password_params(password: "invalid")
    assert_response :unprocessable_entity

    assert_select 'h2', I18n.t("auth.password_reset.title")
  end

  private

  def create_user_with(name:)
    User.create!(
      name: name,
      email: "felipe@taskodoro.com",
      password: "a_valid_password",
      password_confirmation: "a_valid_password"
    )
  end

  def password_reset_params(email:)
    { user: { email: email } }
  end

  def new_password_params(password: "a_valid_password")
    { user:
        {
          password: password,
          password_confirmation: password
        }
    }
  end
end
