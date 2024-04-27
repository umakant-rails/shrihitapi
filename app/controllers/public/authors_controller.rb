class Public::AuthorsController < ApplicationController

  def index
    page = params[:page].present? ? params[:page] : 1
    arr = ["is_approved=TRUE"]
    arr.push("name like '#{params[:start_with]}%'") if params[:start_with].present?

    if arr.present?
      @total_authors = Author.where(arr.join(' and ')).count
      @authors = Author.includes(:articles).where(arr.join(' and ')).page(page).per(10)
    else
      @total_authors = Author.where(arr.join(' and ')).count
      @authors = Author.includes(:articles).where(arr.join(' and ')).order("name ASC").page(page).per(10)
    end

    @authors = @authors.map do | author |
      author.attributes.merge({articles: author.articles})
    end

    render json: {
      total_authors: @total_authors,
      authors: @authors
    }
  end

  def show
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

  def articles_by_author
    @author = Author.where(name: params[:author_name].strip)[0]
    @articles = @author.articles.page(params[:page]) rescue nil
  end

  def sants
    @sants = Author.where("is_approved=TRUE and biography!= ''") rescue []

    render json: {
      sants: @sants
    }
  end

  def sant_biography
    @sants = Author.where("is_approved=TRUE and biography!= ''") rescue []
    @sant = Author.where(name_eng: params[:id].strip).first rescue nil

    render json: {
      sants: @sants,
      sant: @sant
    }
  end

end
