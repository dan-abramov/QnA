class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  after_action  :publish_comment

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user_id = current_user.id
    @comment.save
  end

  private

  def load_commentable
    if params[:comment][:commentable_type] == 'Answer'
      @commentable = Answer.find(params[:comment][:commentable_id])
      gon.answer_id = @commentable.id
    elsif params[:comment][:commentable_type] == 'Question'
      @commentable = Question.find(params[:comment][:commentable_id])
    end
  end

  def publish_comment
    return if @comment.errors.any?
    renderer = ApplicationController.renderer.new
    renderer.instance_variable_set(:@env, { "HTTP_HOST"=>"localhost:3000",
                                            "HTTPS"=>"off",
                                            "REQUEST_METHOD"=>"GET",
                                            "SCRIPT_NAME"=>"",
                                            "warden" => warden })
    ActionCable.server.broadcast(
    path_for_broadcasting,
      renderer.render(
        partial: 'comments/comment_json',
        locals:  { comment: @comment }
      )
    )
  end

  def path_for_broadcasting
    if @commentable.class.name == 'Answer'
      "questions/#{@commentable.question_id}/comments"
    elsif @commentable.class.name == 'Question'
      "questions/#{@commentable.id}/comments"
    end
  end

  def comment_params
    params.require(:comment).permit(:body, :commentable_type, :commentable_id )
  end
end
