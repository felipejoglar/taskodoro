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

# Preview all emails at http://localhost:3000/rails/mailers/password_reset_mailer
class PasswordResetMailerPreview < ActionMailer::Preview
  def password_reset
    user = User.new(name: "Test", email: "email@mail.com", password_digest: "a_password_digest")
    UserMailer.with(user: user, token: "a_token").password_reset
  end
end
