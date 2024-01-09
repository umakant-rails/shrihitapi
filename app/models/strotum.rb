class Strotum < ApplicationRecord
  has_many :strota_articles
  belongs_to :strota_type
  paginates_per 10

end
