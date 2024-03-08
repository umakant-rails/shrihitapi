class Public::TagsController < ApplicationController

  def index 
    @tags = Tag.order("name ASC")
    render json:{
      tags: @tags
    }
  end

  def show
    @tag = Tag.where(name: params[:id]).first rescue nil
    articles = @tag.articles

    articles = articles.map do | article |
      article.attributes.merge({
        author: article.author.name,
        article_type: article.article_type.name
      })
    end

    render json: {
      tag: @tag,
      tags: Tag.first(10),
      articles: articles
    }
  end

end
