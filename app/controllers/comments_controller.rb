class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user_id = current_user.id
    @comment.save
  end

  private

  def load_commentable
    if params[:comment][:commentable_type] == "Answer"
      @commentable = Answer.find(params[:comment][:commentable_id])
    elsif params[:comment][:commentable_type] == "Question"
      @commentable = Question.find(params[:comment][:commentable_id])
    end
  end

  def comment_params
    params.require(:comment).permit(:body, :commentable_type, :commentable_id )
  end
end
