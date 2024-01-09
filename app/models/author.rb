class Author < ApplicationRecord

  has_many :articles
  has_many :saint_bio_events
  has_many :scriptures
  belongs_to :user
  belongs_to :sampradaya, optional: true
  has_many    :stories
  # paginates_per 10

  validates :name, presence: true
  scope :pending, ->() { where(is_approved: nil) }
  scope :approved, ->() { where(is_approved: true) }

  def self.create_author(name, user_id)
    author = self.where(name: name).first
    return (author.present? ? author : self.create!(name: name, user_id: user_id))
  end

end
