class Public::ArticlesController < ApplicationController

  def index
    @articles = Article.order("created_at DESC")
    # @articles = Article.all.paginate(page: 1, per_page: 10)
    @authors = Author.order("created_at DESC")
    @contexts = Context.order("created_at DESC")
    @tags = Tag.order("created_at DESC")
    @article_types = ArticleType.order("created_at DESC") 
    
    articles_tmp = @articles.map do | article |
      article.attributes.merge({author: article.author.name, article_type: article.article_type.name})
    end

    render json: {
      articles: articles_tmp,
      authors: @authors,
      contexts: @contexts,
      tags: @tags,
      article_types: @article_types
    }
      
  end

  def show
    @article = Article.where(hindi_title: params[:id])[0] rescue nil

    if @article.present?
      article_tmp = @article.attributes.merge({
        author: @article.author.name, 
        article_type: @article.article_type.name,
        comments: @article.comments.order("created_at DESC")
      })
      render json: {
        article: article_tmp
      }
    else
      render json: {
        status: 401,
        error: "आपके द्वारा जिस रचना की जानकारी चाही गई थी, वह उपलब्ध नहीं है | \n हमारे पास उपलब्ध रचनाओं की सूची निम्नानुसार है",
      }
    end
  end

  def search_articles
    search_term = params[:term]
    @articles = Article.where("content like ? or LOWER(hindi_title) like ?", "%#{search_term.strip}%", "%#{search_term.strip}%")
    articles_tmp = @articles.map do | article |
      article.attributes.merge({author: article.author.name, article_type: article.article_type.name})
    end

    render json: {
      articles: articles_tmp
    }
  end

end
