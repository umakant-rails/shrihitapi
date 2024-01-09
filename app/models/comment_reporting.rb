class CommentReporting < ApplicationRecord
  belongs_to :user
  belongs_to :article
  belongs_to :comment

  scope :not_read, ->(){ where(comment_reportings: {is_read: false}) }
end
