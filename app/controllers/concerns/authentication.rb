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

module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :user_signed_in?
  end

  def sign_in(user)
    reset_session
    session[:current_user_id] = user.id

    redirect_to home_path(user.id)
  end

  def sign_out
    reset_session
  end

  def redirect_if_authenticated
    redirect_to home_path(current_user.id) if user_signed_in?
  end

  def authenticate_user!
    if current_user.blank?
      redirect_to root_path
    end
  end

  private

  def user_signed_in?
    current_user.present?
  end

  def current_user
    Current.user ||= authenticate_user_from_session
  end

  def authenticate_user_from_session
    session[:current_user_id] && User.find_by(id: session[:current_user_id])
  end
end
