# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[create]
  after_action  :publish_answer, only: %i[create]

  include Votabled

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    @answer.save
  end

  def update
    @answer = Answer.find(params[:id])
    if current_user.id == @answer.user_id
      @answer.update(answer_params)
      @question = @answer.question
    else
      flash[:notice] = 'You can not update this answer'
    end
  end

  def set_best
    @answer = Answer.find(params[:answer_id])
    @question = @answer.question
    if current_user.id == @answer.question.user_id
      @answer.set_best
    else
      flash[:notice] = 'You can not set best answer'
    end
  end

  def destroy
    @answer   = Answer.find(params[:id])
    @question = @answer.question

    if @answer.user_id == current_user.id
      @answer.destroy
    else
      flash[:notice] = 'You can not delete this answer'
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
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
