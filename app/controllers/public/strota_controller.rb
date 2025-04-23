class Public::StrotaController < ApplicationController
  # before_action :set_required_data

  def index 
    strota_types = StrotaType.all
    strota = Strotum.includes(:strota_articles)
    
    strota_tmp = strota.map do | strotum |
      strotum.attributes.merge({
        strota_type: strotum.strota_type.name,
        articles: strotum.strota_articles
      })
    end

    # articles_tmp = @articles.map do | article |
    #   article.attributes.merge({
    #     author: article.author.name, 
    #     article_type: article.article_type.name
    #   })
    # end

    render json:{
      strota_types: strota_types,
      strota: strota_tmp
    }
  end

  def show
    strotum = Strotum.where("title like ?", "%#{params[:id].strip}%").first 
    strotum_articles = strotum.strota_articles.joins(:article_type).order("index ASC") rescue []
    # strota = Strotum.where("strota_type_id = ? and id not in (?)", strotum.strota_type_id, strotum.id) rescue []
    strota = Strotum.where("id not in (?)", strotum.id) rescue []

    strotum_articles = strotum_articles.map do |sa| 
      sa.attributes.merge({article_type: sa.article_type.name})
    end

    render json: {
      strotum: strotum,
      strotum_articles: strotum_articles,
      strota: strota
    }
  end

  def get_strota_by_type
    strota_types = StrotaType.all
    strota_type = StrotaType.where(name: params[:strota_type]).first rescue nil
    strotas = strota_type.strota rescue []

    render json: {
      strota_types: strota_types,
      strotas: strotas
    }
  end

  private
    
    def set_required_data
      @sants = Author.where("biography!= ''").limit(5) rescue []
      @scriptures = Scripture.all.limit(5)
    end

end
