class Admin::DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @articles_by_time = Article.group_by_month(:created_at).count
    @articles_by_type = ArticleType.joins(:articles).group(:name).count
    @artcles_by_context = Context.joins(:articles).group(:name).count
    @contexts_by_approval = {pending: Context.pending.length, approved: Context.approved.length}
    
    # @articles_pending = Article.pending
    # @authors_pending = Author.pending
    # @authors_approved = Author.approved

    # articles_grouped = Article.group(:is_approved).count
    # authors_grouped = Author.group(:is_approved).count
    # tags_grouped = Tag.group(:is_approved).count
    # @spam_comment_reports = CommentReporting.not_read

    # @articles_group_by_approval = {
    #   approved: articles_grouped[true] ? articles_grouped[true] : 0,
    #   pending: articles_grouped[nil] ? articles_grouped[nil] : 0
    # }
    # @authors_group_by_approval = {
    #   approved: authors_grouped[true] ? authors_grouped[true] : 0,
    #   pending: authors_grouped[nil] ? authors_grouped[nil] : 0
    # }
    # @tags_group_by_approval = {
    #   approved: tags_grouped[true] ? tags_grouped[true] : 0,
    #   pending: tags_grouped[nil] ? tags_grouped[nil] : 0
    # }

    @registered_users = User.where("role_id > ?", 2)

    render json: {
      total_articles: Article.count,
      total_authors: Author.count,
      total_tags: Tag.count,
      total_contexts: Context.count,
      articles_by_time: @articles_by_time,
      articles_by_type: @articles_by_type,
      articles_by_context: @artcles_by_context,
      contexts_by_approval: @contexts_by_approval
    }

  end

end
