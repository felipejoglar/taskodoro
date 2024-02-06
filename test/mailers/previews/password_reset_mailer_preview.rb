# Preview all emails at http://localhost:3000/rails/mailers/password_reset_mailer
class PasswordResetMailerPreview < ActionMailer::Preview
  def password_reset
    user = User.new(name: "Test", email: "email@mail.com", password_digest: "a_password_digest")
    UserMailer.with(user: user, token: "a_token").password_reset
  end
end
