# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[create]
  before_action :load_answer, only: %i[update destroy]
  after_action  :publish_answer, only: %i[create]
  authorize_resource


  respond_to :js


  include Votabled

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_user.id)))
  end

  def update
    @answer.update(answer_params)
  end

  def set_best
    @answer   = Answer.find(params[:answer_id])
    @question = @answer.question
    authorize! :set_best, @answer
    @answer.set_best
  end

  def destroy
    @answer.destroy
  end


  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?
    renderer = ApplicationController.renderer.new
    renderer.instance_variable_set(:@env, { "HTTP_HOST"=>"localhost:3000",
                                            "HTTPS"=>"off",
                                            "REQUEST_METHOD"=>"GET",
                                            "SCRIPT_NAME"=>"",
                                            "warden" => warden })
    ActionCable.server.broadcast(
    "questions/#{params[:question_id]}",
      renderer.render(
        partial: 'answers/answer_json',
        locals:  { answer: @answer }
      )
    )
  end
end
