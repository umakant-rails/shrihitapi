class Public::AuthorsController < ApplicationController

  def index
    @authors = Author.includes(:articles).where("name != 'अज्ञात'").order("name ASC")

    authors_tmp = @authors.map do | author |
      author.attributes.merge({aritcles: author.articles})
    end
    render json: {
      authors: authors_tmp
    }
  end

end
