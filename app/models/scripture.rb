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
  has_many :articles

  # has_many :scr_articles, through: :cs_articles

  validates :name, presence: true

  def get_vani_articles(chapter_id, page)
    articles, total_articles = nil, nil
    if chapter_id.present?
      articles = self.articles.where("chapter_id=?", chapter_id).order("index ASC").page(page).per(10)
      total_articles = self.articles.where("chapter_id=?", chapter_id).count
    else
      articles = self.articles.order("index ASC").page(page).per(10)
      total_articles = self.articles.count
    end

    articles = articles.map do |article| 
      article.attributes.merge({
        author: article.author.name,
        article_type: article.article_type.name
      })
    end

    return articles, total_articles
  end

  def get_cs_articles(chapter_id, page)
    articles, total_articles = nil, nil
    if chapter_id.present?
      articles = self.cs_articles.joins(:article)
        .where("chapter_id=?", chapter_id).order("index ASC").page(page).per(10)
      total_articles = self.cs_articles.where("chapter_id=?", chapter_id).count
    else
      articles = self.cs_articles.joins(:article).order("index ASC").page(page).per(10)
      total_articles = self.cs_articles.count
    end

    articles = articles && articles.map do |a| 
      article = a.article
      article.attributes.merge({
        cs_article_id: a.id,
        author: article.author.name,
        chapter: a.chapter.name,
        article_type: article.article_type.name
      })
    end
    return articles, total_articles
  end

  def get_scripture_articles(chapter_id, page)
    articles, total_articles = nil, nil
    if chapter_id.present?
      articles = self.scripture_articles.where("chapter_id=?", chapter_id).order("index ASC").page(page).per(10)
      total_articles = self.scripture_articles.where("chapter_id=?", chapter_id).count
    else
      articles = self.scripture_articles.order("index ASC").page(page).per(10)
      total_articles = self.scripture_articles.count
    end

    articles = articles.map do |article| 
      article.attributes.merge({
        author: article.author.name,
        article_type: article.article_type.name
      })
    end
    return articles, total_articles
  end

  def get_stories(page)
    stories = self.stories.order("index ASC").page(page).per(10)
    total_stories = self.stories.count

    stories = stories.map do |story| 
      story.attributes.merge({
        author: (story.author.name rescue nil)
      })
    end
    return stories, total_stories
  end

  def get_granth_articles(chapter_id, page)
    articles, total_articles = nil, nil

    if chapter_id.present?
      # articles = self.chapters.where("chapter_id=?", chapter_id).joins(:scripture_articles).page(page).per(10) rescue nil
      articles = ScriptureArticle.joins(:chapter).where("chapters.scripture_id=? and chapters.id=?", 
        self.id, chapter_id).page(page).per(10)
      total_articles = self.chapters.where("chapter_id=?", chapter_id).joins(:scripture_articles).count rescue 0

      articles = articles && articles.map do | article |
        # article = a.scripture_article
        article.attributes.merge({article_type: article.article_type.name})
      end
    else
      articles = self.chapters.first.scripture_articles.order("index ASC").page(page).per(10) rescue nil
      total_articles = self.chapters.first.scripture_articles.count rescue 0
      articles = articles.map { | article | 
        article.attributes.merge({article_type: article.article_type.name})
      }
    end

    return articles, total_articles
  end

end
