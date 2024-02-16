class AuthorsController < ApplicationController
  before_action :authenticate_user!

  def index
    page = params[:page].present? ? params[:page] : 1
    
    if params[:start_with].present?
      total_authors = current_user.authors.where("name like '#{params[:start_with]}%'").count
      authors = current_user.authors.where("name like '#{params[:start_with]}%'").page(page).per(10)
    else
      total_authors = current_user.authors.count
      authors = current_user.authors.page(page).per(10)   
    end

    authors_tmp = authors.map do | author |
      author.attributes.merge({
        articles: author.articles
      })
    end

    render json: {
      total_authors: total_authors,
      authors: authors_tmp,
      page: page
    }
  end

  def new
    sampradayas = Sampradaya.all

    render json: {sampradayas: sampradayas}
  end

  def create
    @author = current_user.authors.new(author_params)

    if @author.save
      render json: { article: @author, notice: "Author was created successfully."}
    else
      render json: { article: @author.errors, error: @author.errors.full_messages }
    end
  end

  def sampradaya
    sampradaya = Sampradaya.new(name: params[:sampradaya])
    if sampradaya.save!
      sampradayas = Sampradaya.all
      render json: {sampradayas: sampradayas, notice: "Sampradaya was created successfully."}
    else
      render json: { sampradaya: sampradaya.errors, error: sampradaya.errors.full_messages }
    end
  end

  private

    def author_params
      params.fetch(:author, {}).permit(:name, :name_eng, :sampradaya_id, :biography,
        :birth_date, :death_date, :is_approved)
    end
end
