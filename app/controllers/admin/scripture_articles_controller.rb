  class Admin::ScriptureArticlesController < ApplicationController
  before_action :authenticate_user!
  # before_action :verify_admin
  before_action :set_scripture
  before_action :set_scripture_article, only: %i[show edit update destroy ]

  def index
    @scripture_articles = ScriptureArticle.order("created_at DESC").page(params[:page])
  end

  def new
    @article_types = ArticleType.all
    # @scriptures = Scripture.all
    
    # @scriptures = @scriptures_tmp.map do |scr|
    #   scr.attributes.merge({sections: scr.sections, chapters: scr.chapters})
    # end
    @scripture.attributes.merge({sections: @scripture.sections, chapters: @scripture.chapters})

    render json: {
      scripture: @scripture,
      article_types: @article_types
    }
  end

  def create
    @scripture_article = ScriptureArticle.new(scripture_article_params)

    respond_to do |format|
      if @scripture_article.save
        # format.html { redirect_to admin_scripture_article_url(@scr_article.id), notice: "Scripture Article was successfully created." }
        #format.json { render :show, status: :created, location: @scr_article }
        format.js {}
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @scr_article.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @article_types = ArticleType.all
    @scriptures = Scripture.all
  end

  def update
    respond_to do |format|
      if @scripture_article.update(scripture_article_params)
        format.html { redirect_to admin_scripture_articles_url } #admin_scripture_article_path(@scripture_article.id) }
        format.json { render :show, status: :ok, location: @scripture_article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @scripture_article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @scripture_article.destroy

    respond_to do |format|
      format.html { redirect_to admin_scripture_articles_url, notice: "Scripture Article was successfully destroyed." }
      format.json { head :no_content }
    end
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
