class ScriptureArticle < ApplicationRecord

  belongs_to :scripture
  belongs_to :chapter, optional: true

end
