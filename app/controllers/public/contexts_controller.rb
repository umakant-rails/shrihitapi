class Public::ContextsController < ApplicationController
  def index
    @contexts = Context.order("name ASC")
    
    render json: {
      contexts: @contexts
    }
  end

  def show
    @context = Context.where(name: params[:id]).first rescue nil
    articles = @context.articles

    context_tmp = @context.attributes.merge({
      articles: articles.map do | article |
        article.attributes.merge({
          author: article.author.name,
          article_type: article.article_type.name
        })
      end
    })

    render json: {context: context_tmp}
  end

end
