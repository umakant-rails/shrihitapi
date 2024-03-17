class Public::ContextsController < ApplicationController
  def index
    @contexts = Context.order("name ASC")
    
    render json: {
      contexts: @contexts
    }
  end

  def show
    page = params[:page].present? ? params[:page] : 1

    context = Context.where(name: params[:id]).first rescue nil

    articles = context.articles.page(page).per(10) rescue nil
    total_articles = context.articles.count rescue nil

    articles = articles && articles.map do | article |
      article.attributes.merge({
        author: article.author.name,
        article_type: article.article_type.name
      })
    end

    render json: {
      context: context,
      articles: articles,
      total_articles: total_articles
    }
  end

  def show1
    page = params[:page].present? ? params[:page] : 1

    author = Author.where(name: params[:id]).first rescue nil

    articles = author.articles.page(page).per(10) rescue nil
    total_articles = author.articles.count rescue nil

    articles =  articles && articles.map do | article |
      article.attributes.merge({
        author: article.author.name,
        article_type: article.article_type.name
      })
    end

    render json: {
      author: author,
      articles: articles,
      total_articles: total_articles,
    }
  end

end
