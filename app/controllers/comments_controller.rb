class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: %i[edit update destroy ]
  before_action :set_article

  def create
    @comment = current_user.comments.new(comment_params)
    @comment.commentable = @article

    if @comment.save
      comments = @article.get_comments

      render json: {
        comments: comments,
        notice: 'Comment is created Successfully.'
      }
    else
      render json: { error: @comment.errors }
    end

  end
  
  def edit
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    if @comment.update(comment_params)
      comments = @article.get_comments
      render json: {
        comments: comments,
        notice: 'Comment is updated Successfully.' 
      }
    else
      render json: { error: @comment.errors }
    end
  end

  def reply
    @comment = current_user.comments.new(comment_params)
    @parent_comment = Comment.find(params[:comment][:parent_id]) #.commentable 
    @comment.commentable = @parent_comment

    if @comment.save
      comments = @article.get_comments
      render json: {
        comments: comments,
        notice: 'Replied on comment is Successfully.'
      }
    else
      render json: { error: @comment.errors }
    end

  end

  def destroy
    if @comment.destroy
      comments = @article.get_comments
      render json: {
        comments: comments,
        notice: 'Comment is deleted successfully.'
      }
    end
  end

  private

    def set_comment
      @comment = Comment.find(params[:id])
    end
    
    def set_article
      @article = Article.find(params[:article_id]) 
    end

    def comment_params
      params.fetch(:comment, {}).permit(:comment, :commetable_id, :commetable_type, :user_id, :depth)
    end

end
