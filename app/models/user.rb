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

class User < ApplicationRecord
  has_secure_password

  EMAIL_REQUIREMENTS = URI::MailTo::EMAIL_REGEXP
  PASSWORD_REQUIREMENTS = /\A.{12,64}\z/

  validates :email, :password, :name, presence: true
  validates :email, uniqueness: true
  validates :email, format: EMAIL_REQUIREMENTS
  validates :password, format: PASSWORD_REQUIREMENTS

  normalizes :email, with: -> (email) { email.strip.downcase }

  def password_reset_requested
    UserMailer.with(user: self, token: generate_token_for(:password_reset))
              .password_reset
              .deliver_later
  end

  private

  RESET_PASSWORD_TOKEN_EXPIRATION = 15.minutes

  generates_token_for :password_reset, expires_in: RESET_PASSWORD_TOKEN_EXPIRATION do
    password_salt&.last(12)
  end
end
