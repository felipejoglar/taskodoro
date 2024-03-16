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

