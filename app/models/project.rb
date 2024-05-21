class Project < ApplicationRecord
  belongs_to :user

  validates :title, :user_id, presence: true

  normalizes :description, with: -> (description) { description.blank? ? nil : description }
end
