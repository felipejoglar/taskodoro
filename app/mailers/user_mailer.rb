class UserMailer < ApplicationMailer

  def password_reset
    @user = params[:user]

    mail to: @user.email, subject: t("auth.password_reset.mail.subject")
  end
end
