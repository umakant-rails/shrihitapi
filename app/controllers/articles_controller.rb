class ArticlesController < ApplicationController
  before_action :authenticate_user!

  def new
    tags = Tag.approved.order("name ASC")
    authors = Author.order("name ASC")
    contexts = Context.order("name ASC")
    raags = Raag.order("name ASC")
    article_types = ArticleType.order("name ASC")
    scriptures = Scripture.order("name ASC")
    author = Author.where("name=?", "अज्ञात").first
    context = Context.where("name=?", "अन्य").first

    article = Article.new({author_id: author.id, context_id: context.id})
    
    render json: {
      tags: tags,
      contexts: contexts,
      raags: raags,
      authors: authors,
      article_types: article_types,
      scriptures: scriptures,
      article: article
    }
  end

  # POST /articles or /articles.json
  def create
    @article = current_user.articles.new(article_params)

    if true #@article.save
      render json: { article: @article, notice: "Article was created successfully."}
    else
      render json: { article: @article.errors, error: :unprocessable_entity }
    end
  end

  private

     def article_params
      params.fetch(:article, {}).permit(:content, :raag_id, :scripture_id, :index, :author_id, :article_type_id,
        :theme_id, :context_id, :hindi_title, :english_title, image_attributes:[:image])
    end

end
