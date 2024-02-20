class Admin::ContextsController < ApplicationController
  before_action :authenticate_user!
  # before_action :verify_admin
  before_action :set_context, only: %i[ show edit update destroy ]

  # GET /contexts or /contexts.json
  def index
    page = params[:page].present? ? params[:page] : 1

    if params[:start_with].present?
      @contexts = Context.where("name like '#{params[:start_with]}%'").page(page).per(10)
      @total_contexts = Context.where("name like '#{params[:start_with]}%'").count
    else
      get_contexts_by_page(page)
    end

    render json: {
      contexts: @contexts,
      total_contexts: @total_contexts,
      current_page: page
    }
  end

  # POST /contexts or /contexts.json
  def create
    page = params[:page].present? ? params[:page] : 1
    params[:context][:name] = params[:context][:name].strip
    @context = current_user.contexts.new(context_params)

    if @context.save
      total_contexts = current_user.contexts.count
      contexts = current_user.contexts.order("created_at DESC").page(page).per(10)

      render json: {
        contexts: contexts,
        total_contexts: total_contexts,
        context: @context,
        current_page: 1,
        status: 'Context is created Successfully.'
      }
    else
      render json: { tag: @context.errors, error: @context.errors.full_messages }
    end
  end

  # PATCH/PUT /contexts/1 or /contexts/1.json
  def update
    page = params[:page].present? ? params[:page] : 1

    if @context.update(context_params)
      get_contexts_by_page(1)

      render json: {
        context: @context,
        contexts: @contexts,
        total_contexts: @total_contexts,
        current_page: page,
        status: 'Context is updated Successfully'
      }
    else
      render json: { context: @context.errors, error: @context.errors.full_messages }
    end
  end

  # DELETE /contexts/1 or /contexts/1.json
  def destroy
    @context.destroy
    page = params[:page].present? ? params[:page] : 1

    get_contexts_by_page(1)
    render json: { 
      context: @context,
      contexts: @contexts,
      total_contexts: @total_contexts,
      current_page: 1,
      notice: "प्रसंग को सफलतापूर्वक डिलीट कर दिया गया है."
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_context
      @context = Context.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def context_params
      params.fetch(:context, {}).permit(:name, :is_approved, :user_id)
    end

    def get_contexts_by_page(page)
      @total_contexts = Context.count
      @contexts = Context.order("created_at DESC").page(page).per(10)
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_back_or_to homes_path
      end
    end
end
