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

class Api::V1::LoginController < Api::V1::BaseController
  rescue_from ActionController::ParameterMissing, with: :handle_missing_param

  def create
    check_params

    email = params[:email].strip.downcase
    password = params[:password]

    if (user = User.authenticate_by(email: email, password: password))
      render json: { user: user }, except: :password_digest
    else
      render json: { error: t("auth.log_in.error_message") }, status: :unauthorized
    end

  end

  private

  def check_params
    params.require(:email)
    params.require(:password)
  end

  def handle_missing_param(error)
    render json: { error: error.message }, status: :unprocessable_entity
  end
end
