class SuggestionsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_suggestion , only: %i[show update destroy ]

  def index
  	page = params[:page] ? params[:page] : 1
  	@total_suggestions = current_user.suggestions.count
  	@suggestions = current_user.suggestions.order("created_at DESC").page(page).per(10)

  	render json: {
  		total_suggestions: @total_suggestions,
  		suggestions: @suggestions,
  		page: page
  	}
  end

  def show
  	render json: {suggestion: @suggestion}
  end

  def create
	  @suggestion = current_user.suggestions.new(suggestion_params)
    @suggestion.email = current_user.email
    @suggestion.username = current_user.username
  
    if @suggestion.save
    	render json: { suggestion: @suggestion,	notice: "Suggestion was successfully created."}
    else
    	render json: { suggestion: @suggestion, error: @suggestion.errors}
    end
  end

  def update
  	if @suggestion.update(suggestion_params);
  		render json: { suggestion: @suggestion, notice: "Suggestion was successfully updated."}
  	else 
  		render json: { suggestion: @suggestion, error: @suggestion.errors}
  	end
  end

  def destroy
  	@suggestion.destroy

  	page = params[:page] ? params[:page] : 1
  	@total_suggestions = current_user.suggestions.count
  	@suggestions = current_user.suggestions.order("created_at DESC").page(page).per(10)

  	render json: {
  		total_suggestions: @total_suggestions,
  		suggestions: @suggestions,
  		page: page
  	}
  end

  private

  def suggestion_params
    params.fetch(:suggestion, {}).permit(:email, :username, :title, :description, :user_id)
  end

  def set_suggestion
  	@suggestion = Suggestion.find(params[:id])
  end

end

