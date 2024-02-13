class Article < ApplicationRecord

  belongs_to :author, optional: true
  belongs_to :context, optional: true
  belongs_to :user
  belongs_to :article_type
  has_many :theme_articles
  has_many :theme_chapters
  has_many :comments, as: :commentable
  has_many :comment_reportings
  has_many :article_tags
  has_many :tags, through: :article_tags
  # has_one :image, as: :imageable, dependent: :destroy
  # accepts_nested_attributes_for :image
  has_one :cs_article

  # paginates_per 10

  validates :content, :hindi_title, :english_title, presence: true
  #:author_id, :context_id,

  scope :by_author, ->(author_id) { where('author_id = ?', author_id) }
  scope :by_context, ->(context_id) { where('context_id = ?', context_id) }
  scope :by_article_type, ->(article_type_id) { where('article_type_id = ?', article_type_id) }
  scope :by_id, ->(id){ where("articles.id = ? ", id)}
  scope :by_search_english_term, ->(term) {where("LOWER(english_title) like ? or LOWER(hindi_title) like ?",
      "%#{term.downcase}%", "%#{term.downcase}%")}
  scope :by_search_hindi_term, ->(term) {where("content like ? or LOWER(hindi_title) like ?", "%#{term.strip}%", "%#{term.strip}%")}
  
  scope :by_search_term, ->(term) {where("content like ? or LOWER(hindi_title) like ? or LOWER(english_title) like ?", 
    "%#{term.strip.downcase}%", "%#{term.strip.downcase}%", "%#{term.strip.downcase}%")}
  scope :approved, ->(){ where(is_approved: true) }
  scope :pending, ->(){ where(is_approved: nil) }
  scope :rejected, ->(){ where(is_approved: false) }

  def self.by_attributes_query(author_id, context_id, article_type_id, selected_chapter_id, contributor_id)
    query = ""
    if author_id.present?
      query += "author_id = #{author_id}"
    end
    if context_id.present?
      query += query.blank? ? "context_id = #{context_id}" : " and context_id = #{context_id}"
    end
    if article_type_id.present?
      query += query.blank? ? "article_type_id = #{article_type_id}" : " and article_type_id = #{article_type_id}"
    end
    if contributor_id.present?
      query += query.blank? ? "user_id = #{contributor_id}" : " and user_id = #{contributor_id}"
    end
    #return Article.where(query)
    return query
  end
end
