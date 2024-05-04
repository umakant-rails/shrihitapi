class Public::SuggestionsController < ApplicationController

  def index
  	page = params[:page] ? params[:page] : 1
  	@total_suggestions = Suggestion.count
  	@suggestions = Suggestion.order("created_at DESC").page(page).per(10)

  	render json: {
  		total_suggestions: @total_suggestions,
  		suggestions: @suggestions,
  		page: page
  	}
  end

  def show
  	@suggestion = Suggestion.find(params[:id])
  	render json: {suggestion: @suggestion}
  end

  def create
  	if current_user.present?
      @suggestion = current_user.suggestions.new(suggestion_params)
      @suggestion.email = current_user.email
      @suggestion.username = current_user.username
    else 
      @suggestion = Suggestion.new(suggestion_params)
    end

    if @suggestion.save
    	render json: {
    		suggestion: @suggestion, 
    		notice: "Suggestion was successfully created."
    	}
    else
    	render json: {
    		suggestion: @suggestion, 
    		error: @suggestion.errors
    	}
    end
  end

  private

  def suggestion_params
    params.fetch(:suggestion, {}).permit(:email, :username, :title, :description, :user_id)
  end

end
