class CsArticle < ApplicationRecord
  belongs_to :article
  belongs_to :scripture
  belongs_to :user
  belongs_to :chapter, optional: true
end
