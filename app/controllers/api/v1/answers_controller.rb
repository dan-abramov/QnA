class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: %i[index create]

  authorize_resource

  def index
    respond_with @question.answers
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_resource_owner.id)))
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
