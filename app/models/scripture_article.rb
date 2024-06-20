class ScriptureArticle < ApplicationRecord

  belongs_to :scripture
  belongs_to :article_type
  belongs_to :chapter, optional: true

end
