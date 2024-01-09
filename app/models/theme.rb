class Theme < ApplicationRecord

  
  has_many :contexts, dependent: :nullify
  has_many :theme_chapters, dependent: :destroy
  has_many :theme_articles, dependent: :destroy
  has_many :articles, through: :theme_articles
  belongs_to :user

  validates :name, presence: true

end
