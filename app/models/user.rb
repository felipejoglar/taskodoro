class User < ApplicationRecord
  include Resettable

  has_secure_password

  has_many :projects, dependent: :destroy

  after_create :create_default_project

  EMAIL_REQUIREMENTS = URI::MailTo::EMAIL_REGEXP
  PASSWORD_REQUIREMENTS = /\A.{12,64}\z/

  validates :email, :password, :name, presence: true
  validates :email, uniqueness: true
  validates :email, format: EMAIL_REQUIREMENTS
  validates :password, format: PASSWORD_REQUIREMENTS

  normalizes :email, with: -> (email) { email.strip.downcase }

  private

  def create_default_project
    self.projects.create(title: "Inbox")
  end
end
