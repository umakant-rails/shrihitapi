class Strotum < ApplicationRecord
  has_many :strota_articles
  belongs_to :strota_type

end
