class ArticleType < ApplicationRecord
  
  belongs_to :user
  has_many :articles
  validates :name, presence: true

end
