class Suggestion < ApplicationRecord
  belongs_to :user, optional: true

  validates :email, presence: true
  validates :username, presence: true
  validates :title, presence: true
  validates :description, presence: true

end
