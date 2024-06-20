  class Admin::ScriptureArticlesController < ApplicationController
  before_action :authenticate_user!
  # before_action :verify_admin
  before_action :set_scripture
  before_action :set_scripture_article, only: %i[show edit update destroy ]

  def index
    page = params[:page].present? ? params[:page] : 1
    
    get_page_by_articles(page)

    render json: {
      articles: @articles,
      total_articles: @total_articles,
      current_page: page
    }
  end

  def show
    @scripture_article = ScriptureArticle.find(params[:id])
    @article_types = ArticleType.all

    render json: {
      scripture: @scripture,
      article_types: @article_types,
      sections: @scripture.sections,
      chapters: @scripture.chapters,
      scripture_article: @scripture_article,
    }
  end

  def new
    @article_types = ArticleType.all

    render json: {
      scripture: @scripture,
      article_types: @article_types,
      sections: @scripture.sections,
      chapters: @scripture.chapters,
    }
  end

  def create
    @scripture_article = @scripture.scripture_articles.new(scripture_article_params)

    if @scripture_article.save
      render json: {
        scripture_article: @scripture_article,
        notice: "Scripture Article is created successfully"
      }
    else
      render json: {
        scripture_article: @scripture_article.errors, 
        errors: @scripture_article.errors.full_messages 
      }
    end

  end

  def update
    if @scripture_article.update(scripture_article_params)
      render json: {
        updated_scr_article: @scripture_article,
        notice: "Scripture Article is updated successfully."
      }
    else
      render json: {
        scripture_article: @scripture_article.errors, 
        errors: @scripture_article.errors.full_messages 
      }
    end

  end

  def destroy
    page = params[:page].present? ? params[:page] : 1
    @scripture_article.destroy
    get_page_by_articles(page)

    render json: {
      articles: @articles,
      total_articles: @total_articles,
      current_page: page,
      notice: "Scripture Article is deleted successfully."
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.    
    def set_scripture
      @scripture = Scripture.find(params[:scripture_id])
    end
    def set_scripture_article
      @scripture_article = ScriptureArticle.find(params[:id])
    end
    # Only allow a list of trusted parameters through.
    def scripture_article_params
      params.fetch(:scripture_article, {}).permit(:scripture_id, :article_type_id, :content, :content_eng, 
        :interpretation, :interpretation_eng, :chapter_id, :index)
    end

    def get_page_by_articles(page)
      if params[:chapter_id].present?
        @chapter = Chapter.find(params[:chapter_id]);
        @articles = @chapter.scripture_articles.order("index ASC").page(page).per(10)
        @total_articles = @chapter.scripture_articles.count
      else
        @articles = @scripture.scripture_articles.page(page).per(10)
        @total_articles = @scripture.scripture_articles.count
      end
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_back_or_to homes_path
      end
    end
end
