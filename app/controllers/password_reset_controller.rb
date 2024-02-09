# frozen_string_literal: true

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

class PasswordResetController < ApplicationController
  before_action :user_by_token, only: [:edit, :update]

  def new
  end

  def create
    User.find_by(email: params[:user][:email])&.password_reset_requested

    redirect_to signin_path, notice: t("auth.password_reset.message.confirmation")
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

    redirect_to forgot_password_path, notice: t("auth.password_reset.message.expired") unless @user.present?
  end
end
