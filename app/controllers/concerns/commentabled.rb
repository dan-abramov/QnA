module Commentabled
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :load_commentable, except: %i[index]
  end

  def comment
    @comment = @commentable.comments.new(comment_params)
    @comment.user_id = current_user.id
    @comment.save
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_commentable
    @commentable = model_klass.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
