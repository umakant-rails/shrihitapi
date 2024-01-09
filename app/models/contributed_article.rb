class ContributedArticle < ApplicationRecord
  validates :content, presence: true
end
