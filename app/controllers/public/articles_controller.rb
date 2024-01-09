class Public::ArticlesController < ApplicationController

  def index
    @articles = Article.order("created_at DESC").first(10)
    @authors = Author.order("created_at DESC").first(10)
    @contexts = Context.order("created_at DESC").first(10)
    @tags = Tag.order("created_at DESC").first(10)
    @article_types = ArticleType.order("created_at DESC").first(10)
    
    articles_tmp = @articles.map do | article |
      article.attributes.merge({author: article.author.name, article_type: article.article_type.name})
    end

    render json: {
      articles: articles_tmp,
      authors: @authors,
      contexts: @contexts,
      tags: @tags,
      article_types: @article_types
    }
      
  end

  def show
    @article = Article.where(hindi_title: params[:id])[0] rescue nil
    if @article.present?
      @comments = @article.comments.order("created_at DESC")
    else
      flash[:notice] = "आपके द्वारा जिस रचना की जानकारी चाही गई थी, वह उपलब्ध नहीं है | \n हमारे पास उपलब्ध रचनाओं की सूची निम्नानुसार है"
      redirect_back_or_to public_articles_path
    end
  end

end
