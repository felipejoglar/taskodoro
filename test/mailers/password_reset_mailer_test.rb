require "test_helper"

class UserMailerTest < ActionMailer::TestCase

  test "passwords sends the token in the URL" do
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
