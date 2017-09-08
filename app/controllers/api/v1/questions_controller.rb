class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: %i[show]

  skip_authorization_check #_______________________________________поменять перед отправкой

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    respond_with Question.where(id: @question.id)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end
end
