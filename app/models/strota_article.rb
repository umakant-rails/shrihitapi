class StrotaArticle < ApplicationRecord
  belongs_to :strotum
  belongs_to :article_type

  paginates_per 10
end
