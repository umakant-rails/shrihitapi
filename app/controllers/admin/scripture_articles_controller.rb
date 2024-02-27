  class Admin::ScriptureArticlesController < ApplicationController
  before_action :authenticate_user!
  # before_action :verify_admin
  before_action :set_scripture
  before_action :set_scripture_article, only: %i[show edit update destroy ]

  def index
    page = params[:page].present? ? params[:page] : 1
    
    if params[:chapter_id].present?
      @chapter = Chapter.find(params[:chapter_id]);
      @articles = @chapter.scripture_articles.order("index ASC").page(page).per(10)
      @total_articles = @chapter.scripture_articles.count
    else
      @articles = @scripture.scripture_articles.page(page).per(10)
      @total_articles = @scripture.scripture_articles.count
    end

    render json: {
      articles: @articles,
      total_articles: @total_articles,
      current_page: page
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
        scripture_article: @scripture_article,
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
    @scripture_article.destroy

    render json: {
      scripture_article: @scripture_article,
      notice: "Scripture Article is deleted successfully."
    }
  end

  def edit_article_index
    @scriptures = Scripture.all
  end

  def update_article_index
    @scripture_article = ScriptureArticle.find(params[:article_id])
    respond_to do |format|
      if @scripture_article.update({index: params[:article_index]})
        format.html { }
        format.js { render status: 200 }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @scripture_article.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_chapters
    @scripture = Scripture.find(params[:scripture_id]) rescue nil
    @chapters = @scripture.present? ? @scripture.chapters : nil
    @last_article = @scripture.scripture_articles.order("index ASC").last rescue nil
  end

  def get_chapter_articles
    
    if params[:scripture_id].present?
      @scripture = Scripture.find(params[:scripture_id]) rescue nil
      @chapters = @scripture.present? ? @scripture.chapters : nil
      @articles = @chapters.blank? ? @scripture.scripture_articles.order("index ASC").page(params[:page]) : nil
    else
      @chapter = Chapter.find(params[:chapter_id])
      @articles = @chapter.scripture_articles.order("index ASC").page(params[:page])
    end
  end

  def get_index
    @chapter = Chapter.find(params[:chapter_id])
    @last_article = @chapter.scripture_articles.order("index ASC").last rescue nil
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

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_back_or_to homes_path
      end
    end
end
