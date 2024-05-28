class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user

  before_validation :set_user, :set_default_due_date, on: :create

  validates :title, :project_id, :user_id, :due_date,  presence: true

  normalizes :description, with: -> (description) { description.blank? ? nil : description }

  private

  def set_user
    self.user = Current.user
  end

  def set_default_due_date
    self.due_date ||= Date.today
  end
end
