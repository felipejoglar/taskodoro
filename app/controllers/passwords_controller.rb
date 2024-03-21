class PasswordsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :user_by_token, only: [:edit, :update]

  def new
  end

  def create
    User.find_by(email: params[:user][:email])&.password_reset_requested

    redirect_to new_signin_path, notice: t("auth.password_reset.message.confirmation")
  end

  def edit
  end

  def update
    if @user.update(password_params)
      sign_in @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def user_by_token
    @user = User.find_by_token_for(:password_reset, params[:token])

    redirect_to new_forgot_password_path, notice: t("auth.password_reset.message.expired") unless @user.present?
  end
end
