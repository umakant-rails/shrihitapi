class Admin::StrotaArticlesController < ApplicationController
  before_action :authenticate_user!
  # before_action :verify_admin
  before_action :set_strotum
  before_action :set_strota_article, only: %i[show edit update destroy ]

  # GET /strota_articles or /strota_articles.json
  def index
    @strota = Strotum.all
    @strota_articles = @strotum.strota_articles.order("created_at DESC").page(params[:page])
  end

  # GET /strota_articles/1 or /strota_articles/1.json
  def show
  end

  # GET /strota_articles/new
  def new
    @strota = Strotum.all
    article = nil
    # @strotum = Strotum.find(params[:id]) if params[:id].present?

    if @strotum && @strota_article.blank?
      article = @strotum.strota_articles.order("index ASC").last rescue nil
    elsif @strota_article.present?
      article = @strota_article
    end

    if article.present?
      @strota_article = @strotum.strota_articles.new(
        article_type_id: article.article_type_id,
        index: article.index+1)
    else
      @strota_article = @strotum.strota_articles.new(index: 1)
    end
  end

  # GET /strota_articles/1/edit
  def edit
    @strota = Strotum.all
    @article_types = ArticleType.all
  end

  # POST /strota_articles or /strota_articles.json
  def create
    params[:strota_article][:article_type_id] = 6 if params[:strota_article][:article_type_id].blank?
    @strota_article = @strotum.strota_articles.new(strota_article_params)

    if @strota_article.save
      @strotum_articles = @strotum.strota_articles.order("index ASC")
      render json: {
        strota_article: @strota_article,
        strotum_articles: @strotum_articles,
        notice: 'Article is created successfully'
      }
    else
      render json: { 
        strotum: @strota_article.errors,
        error: @strota_article.errors.full_messages
      }
    end
  end

  # PATCH/PUT /strota_articles/1 or /strota_articles/1.json
  def update
    params[:strota_article][:article_type_id] = 6 if params[:strota_article][:article_type_id].blank?

    if @strota_article.update(strota_article_params)
      @strotum_articles = @strotum.strota_articles.order("index ASC")
      render json: {
        strota_article: @strota_article,
        strotum_articles: @strotum_articles,
        notice: 'Article is updated successfully'
      }
    else
      render json: { 
        strotum: @strota_article.errors,
        error: @strota_article.errors.full_messages
      }
    end
  end

  # DELETE /strota_articles/1 or /strota_articles/1.json
  def destroy
    @strota_article.destroy

    respond_to do |format|
      format.html { redirect_to admin_strotum_strota_articles_url(params[:strotum_id]), notice: "Strota article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def update_index
    @article = StrotaArticle.find(params[:id])
    
    if @article.update(index: params[:new_index])
      @strotum_articles = @strotum.strota_articles.order("index ASC")
      render json: {
        strotum_articles: @strotum_articles,
        notice: "रचना का अनुक्रम अद्यतित कर दिया गया है."
      }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_strotum
      @strotum = Strotum.find(params[:strotum_id]) rescue nil
    end

    def set_strota_article
      @strota_article = StrotaArticle.find(params[:strotum_id])
    end

    # Only allow a list of trusted parameters through.
    def strota_article_params
      params.require(:strota_article).permit(:strotum_id, :article_type_id, :index, :content, :interpretation)
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_back_or_to homes_path
      end
    end
end
