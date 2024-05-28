class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :title, :user_id, presence: true

  normalizes :description, with: -> (description) { description.blank? ? nil : description }
end
