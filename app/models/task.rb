class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :title, :project_id, :user_id, :due_date,  presence: true

  normalizes :description, with: -> (description) { description.blank? ? nil : description }
end
