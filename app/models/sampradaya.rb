class Sampradaya < ApplicationRecord
  
  has_many :authors
  has_many :scriptures

  validates :name, presence: true

end
