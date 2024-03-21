require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest

  test "creating a new session" do
    email = "felipe@taskodoro.com"
    password = "a_valid_password"

    get sign_in_url

    assert_response :ok
    assert_select 'h2', I18n.t("auth.sign_in.title")

    create_user_with(email: email, password: password)

    post sign_in_url, params: login_params(email: email, password: password)
    assert session["current_user_id"], "User should be logged in after creation"

    follow_redirect!
    assert_response :ok
    assert_select 'h1', 'Welcome Felipe'
  end

  test "failing to create a new session" do
    email = "felipe@taskodoro.com"
    password = "a_valid_password"

    get sign_in_url

    assert_response :ok
    assert_select 'h2', I18n.t("auth.sign_in.title")

    create_user_with(email: email, password: password)

    post sign_in_url, params: login_params(email: "not_signed_up@email.com", password: password)
    assert_response :unprocessable_entity

    assert_select 'div.alert', 1
  end

  test "destroy current session" do
    email = "felipe@taskodoro.com"
    password = "a_valid_password"

    create_user_with(email: email, password: password)
    post sign_in_url, params: login_params(email: email, password: password)
    assert session["current_user_id"], "User should be logged in after creation"
    follow_redirect!

    delete sign_out_url
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
