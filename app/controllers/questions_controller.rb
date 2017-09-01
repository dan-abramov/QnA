# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  before_action :load_answer, only: %i[show]

  after_action :publish_question, only: %i[create]

  respond_to :html

  authorize_resource

  include Votabled

  def index
    respond_with(@questions = Question.all)
  end

  def show
    gon.question_id     = @question.id
    gon.user_signed_in  = user_signed_in?
    gon.current_user_id = current_user.id if user_signed_in?

    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit; end

  def create
    respond_with(@question = Question.create(question_params.merge(user_id: current_user.id)))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with @question.destroy
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def load_answer
    @answer = @question.answers.build
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def publish_question
    return if @question.errors.any?
    renderer = ApplicationController.renderer.new
    renderer.instance_variable_set(:@env, { "HTTP_HOST"=>"localhost:3000",
                                            "HTTPS"=>"off",
                                            "REQUEST_METHOD"=>"GET",
                                            "SCRIPT_NAME"=>"",
                                            "warden" => warden })
    ActionCable.server.broadcast(
    'questions',
      renderer.render(
        partial: 'questions/question_json',
        locals:  { question: @question }
      )
    )
  end
end
