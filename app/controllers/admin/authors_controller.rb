class Admin::AuthorsController < ApplicationController
  before_action :authenticate_user!

  def index
    page = params[:page].present? ? params[:page] : 1
    get_authors_with_params(page)
    render json: {
      total_authors: @total_authors,
      authors: @authors,
      current_page: page
    }
  end
  
  def author_approved
    page = params[:page].present? ? params[:page] : 1
    @author = Author.find(params[:id])

    if @author.update(is_approved: true)
      get_authors_with_params(page)
      render json: { 
        total_authors: @total_authors,
        authors: @authors,
        current_page: page
      }
    else
      render json: { error: @author.errors.full_messages }
    end
  end

  def destroy
    page = params[:page].present? ? params[:page] : 1
    @author = Author.find(params[:id])

    if @author.destroy
      get_authors_with_params(page)
      render json: { 
        total_authors: @total_authors,
        authors: @authors,
        current_page: page,
      }
    else
      render json: { error: @author.errors.full_messages }
    end
  end

  private 
    def get_authors_with_params(page)      
      arr = []

      arr.push('is_approved is true') if params[:status].present? && params[:status] == "approved"
      arr.push('(is_approved is not true)') if params[:status].present? && params[:status] == "pending"
      arr.push("name like '#{params[:start_with]}%'") if params[:start_with].present?


      if arr.present?
        queryy = arr.join(' and ')
        @total_authors = Author.where(queryy).count
        @authors = Author.where(queryy).order("name ASC").page(page).per(10)
      else
        @total_authors = Author.count
        @authors = Author.order("name ASC").order("name ASC").page(page).per(10)   
      end

      @authors = @authors.map do | author |
        author.attributes.merge({
          articles: author.articles
        })
      end
    end
end
