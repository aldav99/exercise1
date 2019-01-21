module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, except: [:index, :create, :new ]
    after_action :publish_comment, only: [:add_comment]
  end

  def add_comment
    # authorize! :add_comment, Comment
    authorize! :create, Comment
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        res = {body: @comment.body, id: @commentable.id, type: @comment.commentable_type}
        format.json { render json: res }
      else
        res = {errors: @comment.errors.full_messages, id: @comment.commentable_id, type: @comment.commentable_type}
        format.json { render json: res, status: :unprocessable_entity }
      end
    end
  end

  private

  def publish_comment
    return if @comment.errors.any?
    if @comment.commentable_type.downcase == "question"
      @id = @comment.commentable.id
    else
      @id = @comment.commentable.question.id
    end
    ActionCable.server.broadcast(
        "comment_#{@comment.commentable_type.downcase}_#{@id}",
        comment: @comment
      )
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end