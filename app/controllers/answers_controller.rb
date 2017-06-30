# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question

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
    if current_user.id == @answer.question.user_id
      @answer.set_best
    else
      flash[:notice] = 'You can not set best answer'
    end
  end

  def destroy
    @answer = @question.answers.find(params[:id])
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
end
