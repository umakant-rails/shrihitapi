class ThemeChapter < ApplicationRecord

  belongs_to :user
  belongs_to :theme
  has_many :theme_articles
  has_many :articles, through: :theme_articles

  validates :name, presence: true

end
