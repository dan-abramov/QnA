class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  after_action  :publish_comment

  respond_to :js

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user_id: current_user.id)))
  end

  private

  def load_commentable
    @commentable = Answer.find(params[:comment][:commentable_id]) if commentable_is_answer
    gon.answer_id = @commentable.id if commentable_is_answer

    @commentable ||= Question.find(params[:comment][:commentable_id])
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
    path = "questions/#{@commentable.question_id}/comments" if @commentable.class.name == 'Answer'
    path ||="questions/#{@commentable.id}/comments"
  end

  def commentable_is_answer
    params[:comment][:commentable_type] == 'Answer'
  end

  def comment_params
    params.require(:comment).permit(:body, :commentable_type, :commentable_id )
  end
end
