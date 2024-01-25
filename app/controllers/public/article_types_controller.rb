class Public::ArticleTypesController < ApplicationController
  def index
    @article_types = ArticleType.includes(:articles).order("name ASC")

    article_types = @article_types.map do | at |
      at.attributes.merge({articles: at.articles})
    end

    # types_tmp = @article_types.map do | type |
    #   type.attributes.merge({
    #     articles: type.articles.map do | article |
    #       article.attributes.merge({
    #         author: article.author.name,
    #         article_type: article.article_type.name
    #       })
    #     end
    #   })
    # end
    render json: {
      article_types: @article_types
    }
  end
  
  def show
    @article_type = ArticleType.where(name: params[:id]).first rescue nil
    articles = @article_type.articles

    article_type_tmp = @article_type.attributes.merge({
      articles: articles.map do | article |
        article.attributes.merge({
          author: article.author.name,
          article_type: article.article_type.name
        })
      end
    })

    render json: {article_type: article_type_tmp}
  end

end
