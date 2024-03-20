class User < ApplicationRecord
  include Resettable

  has_secure_password

  has_many :projects, dependent: :destroy

  EMAIL_REQUIREMENTS = URI::MailTo::EMAIL_REGEXP
  PASSWORD_REQUIREMENTS = /\A.{12,64}\z/

  validates :email, :password, :name, presence: true
  validates :email, uniqueness: true
  validates :email, format: EMAIL_REQUIREMENTS
  validates :password, format: PASSWORD_REQUIREMENTS

  normalizes :email, with: -> (email) { email.strip.downcase }
end
