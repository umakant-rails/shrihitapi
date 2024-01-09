class Scripture < ApplicationRecord

  belongs_to :user
  belongs_to :scripture_type
  belongs_to :author, optional: true
  belongs_to :sampradaya, optional: true
  has_many :chapters, -> { chapter_scope }, dependent: :destroy
  has_many :sections, -> { section_scope }, foreign_key: 'scripture_id', class_name: 'Chapter'
  has_many :scripture_articles, dependent: :destroy 
  has_many :stories
  has_many :cs_articles
  has_many :c_articles, :through => :cs_articles
  has_many :articles

  validates :name, presence: true

end
