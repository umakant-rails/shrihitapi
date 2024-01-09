class ThemeArticle < ApplicationRecord
  belongs_to :theme
  belongs_to :theme_chapter
  belongs_to :article
  belongs_to :user
end
