module Votabled
  extend ActiveSupport::Concern

  included do
    before_action :load_votabled, only: %i[vote_up vote_down vote_reset]
  end

  def vote_up
    if user_is_not_a_author
      @votabled.vote_up(current_user)
      respond_to_json
    end
  end

  def vote_down
    if user_is_not_a_author
      @votabled.vote_down(current_user)
      respond_to_json
    end
  end

  def vote_reset
    if @votabled.voted?(current_user) && user_is_not_a_author
      @votabled.vote_reset(current_user)
      respond_to_json
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_votabled
    @votabled = model_klass.find(params[:id])
  end

  def respond_to_json
    respond_to do |format|
      format.json { render json: {id: @votabled.id, rating: @votabled.rating}.to_json }
    end
  end

  def user_is_not_a_author
    !current_user.author_of?(@votabled)
  end
end
