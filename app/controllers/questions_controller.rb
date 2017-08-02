# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]

  after_action :publish_question, only: %i[create]

  include Votabled
  include Commentabled

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build

    gon.question_id     = @question.id
    gon.user_signed_in  = user_signed_in?

    if user_signed_in?
      gon.current_user_id = current_user.id
    end
  end

  def new
    @question = Question.new
  end

  def edit; end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id

    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      flash[:notice] = 'Something goes wrong, please, try again.'
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to question_path(@question)
    else
      render :edit
    end
  end

  def destroy
    if @question.user_id == current_user.id
      @question.destroy
      redirect_to questions_path
    else
      flash[:notice] = 'You can not delete this question'
      redirect_to questions_path
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
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
        partial: 'questions/question',
        locals:  { question: @question }
      )
    )
  end
end
