class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :create]
  before_action :redirect_if_authenticated, only: :show

  layout "landing"
  def create
    if (user = User.authenticate_by(authentication_params))
      sign_in user
    else
      flash.now[:alert] = t("auth.sign_in.error_message")
      render :show, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def authentication_params
    params.require(:user).permit(:email, :password)
  end
end
