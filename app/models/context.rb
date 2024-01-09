class Context < ApplicationRecord
  has_many :articles
  belongs_to :theme, optional: true
  belongs_to :user, optional: true

  scope :pending, ->() { where(is_approved: false) }
  scope :approved, ->() { where(is_approved: true) }
  # paginates_per 10

  validates :name, presence: true

end
