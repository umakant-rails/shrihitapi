class Public::HomeController < ApplicationController
  
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

  def get_footer_data
    @authors = Author.order("created_at DESC").first(10)
    @contexts = Context.order("created_at DESC").first(10)
    @tags = Tag.order("created_at DESC").first(10)
    @article_types = ArticleType.order("created_at DESC").first(10)

    render json: {
      authors: @authors,
      contexts: @contexts,
      tags: @tags,
      article_types: @article_types
    }
  end

end
