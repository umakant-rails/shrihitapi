class Public::TagsController < ApplicationController

  def index 
    @tags = Tag.order("name ASC")
    render json:{
      tags: @tags
    }
  end

end
