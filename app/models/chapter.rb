class Chapter < ApplicationRecord

  belongs_to :scripture
  has_many :scripture_articles
  has_many :cs_articles
  has_many :articles, :through => :cs_articles

  has_many :chapters, foreign_key: 'parent_id', class_name: 'Chapter'
  belongs_to :section, foreign_key: 'parent_id', class_name: 'Chapter', optional: true  

  scope :chapter_scope, ->() { where(is_section: false) }
  scope :section_scope, ->() { where(is_section: true) }
  scope :chapters, ->() { where(is_section: false) }

  validates :name, presence: true

  paginates_per 10

end
