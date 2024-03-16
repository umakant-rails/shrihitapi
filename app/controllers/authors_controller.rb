class AuthorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_author, only: %i[ show edit update destroy ]

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
      current_page: page
    }
  end

  def new
    sampradayas = Sampradaya.order("name ASC")

    render json: {sampradayas: sampradayas}
  end

  def create
    params[:author][:is_approved] = (current_user.role_id == 1) ? true : false
    @author = current_user.authors.new(author_params)

    if @author.save
      render json: { author: @author, notice: "Author was created successfully."}
    else
      render json: { author: @author.errors, error: @author.errors.full_messages }
    end
  end

  def show
    if params[:action_type] == "edit"
      sampradayas = Sampradaya.order("name ASC")
      render json: { sampradayas: sampradayas, author: @author }
    else
      render json: { author: @author }
    end
  end

    # PUT/PATCH /authors or /authors.json
  def update
    if @author.update(author_params)
      render json: { author: @author, notice: "रचनाकार को सफलतापूर्वक अद्यतित कर दिया गया है."}
    else
      render json: { author: @author.errors, error: @author.errors.full_messages }
    end
  end

  # DELETE /authors or /authors.json
  def destroy
    if @author.destroy
      page = params[:page].present? ? params[:page] : 1
      total_authors = current_user.authors.count
      authors = current_user.authors.page(page).per(10)  

      render json: { 
        author: @author,
        total_authors: total_authors,
        authors: authors,
        current_page: page,
        notice: "रचना को सफलतापूर्वक डिलीट कर दिया गया है."
      }
    else
      render json: { error: @author.errors.full_messages }
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

    def set_author
      @author = current_user.authors.find(params[:id]) rescue nil
    end
end
