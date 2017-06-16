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
      redirect_to @question
    end
  end

  def destroy
    @answer = @question.answers.find(params[:id])
    if @answer.user_id == current_user.id
      @answer.destroy
      redirect_to @question
    else
      flash[:notice] = 'You can not delete this answer'
      redirect_to @question
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
