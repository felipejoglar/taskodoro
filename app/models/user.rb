class User < ApplicationRecord
  has_secure_password

  has_many :projects, dependent: :destroy

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
