class Public::ArticlesController < ApplicationController

  def index
    page = params[:page].present? ? params[:page] : 1

    @total_articles = Article.where("is_approved=?", true).count
    @articles = Article.where("is_approved=?", true).order("created_at DESC").page(page).per(10)
    @authors = Author.order("created_at DESC")
    @contexts = Context.order("created_at DESC")
    @tags = Tag.order("created_at DESC")
    @article_types = ArticleType.order("created_at DESC")
    
    @articles = @articles.map do | article |
      article.attributes.merge({author: article.author.name, article_type: article.article_type.name})
    end

    render json: {
      articles: @articles,
      total_articles: @total_articles,
      authors: @authors,
      contexts: @contexts,
      tags: @tags,
      article_types: @article_types
    }
      
  end

  def show
    article = Article.where("hindi_title like ?", "%#{params[:id].strip}%")[0] rescue nil

    related_articles = article.context.present? ? article.context.articles.where("id not in (?)", article.id).first(10) : nil
    related_articles = article.tags[0].aritlces.where("id not in (?)", article.id).first(10) if related_articles.blank?
    related_articles = article.author.aritlces.where("id not in (?)", article.id).first(10) if related_articles.blank?
    related_articles = article.aritcle_type.aritlces.where("id not in (?)", article.id).first(10) if related_articles.blank?
    related_articles = Article.where("id > ?", article.id).first(10) if related_articles.blank?

    tags = Tag.all
    contexts = Context.all

    if article.present?
      comments = article.get_comments

      article_tmp = article.attributes.merge({
        author: article.author.name, 
        article_type: article.article_type.name,
        comments: comments

      })
      render json: {
        article: article_tmp,
        related_articles: related_articles,
        tags: tags,
        contexts: contexts
      }
    else
      render json: {
        status: 401,
        error: ["आपके द्वारा जिस रचना की जानकारी चाही गई थी, वह उपलब्ध नहीं है | \n हमारे पास उपलब्ध रचनाओं की सूची निम्नानुसार है"],
      }
    end
  end

  def search_articles
    page = params[:page]
    search_term = params[:term].strip rescue ''

    @articles = Article.where("is_approved=TRUE and (content like ? or LOWER(hindi_title) like ?)", 
      "%#{search_term.strip}%", "%#{search_term.strip}%")
    articles = page.present? ? @articles.page(page).per(10) : @articles
    total_articles = @articles.count

    articles_tmp = articles.map do | article |
      article.attributes.merge({author: article.author.name, article_type: article.article_type.name})
    end

    render json: {
      articles: articles_tmp,
      total_articles: total_articles
    }
  end

  def get_aritcles_by_page
    page = params[:page].present? ? params[:page] : 1

    @total_articles = Article.count
    @articles = Article.where("is_approved=TRUE").order("created_at DESC").page(page).per(10)

    @articles = @articles.map do | article |
      article.attributes.merge({author: article.author.name, article_type: article.article_type.name})
    end

    render json: {
      articles: @articles,
      total_articles: @total_articles,
    }
  end

end
