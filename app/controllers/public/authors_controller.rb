class Public::AuthorsController < ApplicationController

  def index
    @authors = Author.includes(:articles).where("name != 'अज्ञात'").order("name ASC")

    authors_tmp = @authors.map do | author |
      author.attributes.merge({articles: author.articles})
    end
    render json: {
      authors: authors_tmp
    }
  end

  def articles_by_author
    @author = Author.where(name: params[:author_name].strip)[0]
    @articles = @author.articles.page(params[:page]) rescue nil
  end

  def sants
    @sants = Author.where("biography!= ''") rescue []

    render json: {
      sants: @sants
    }
  end

  def sant_biography
    @sants = Author.where("biography!= ''") rescue []
    @sant = Author.where(name_eng: params[:id].strip).first rescue nil

    render json: {
      sants: @sants,
      sant: @sant
    }
  end

end
