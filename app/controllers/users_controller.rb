class UsersController < ApplicationController
  skip_before_action :authenticate_user!

  layout "landing"

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in @user
    else
      render :show, status: :unprocessable_entity
    end
  end

  def show
    @user = User.new
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
