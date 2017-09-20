class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @subscription = current_user.subscriptions.create(subscription_params)
    respond_with(@subscription.question)
  end

  def destroy
    @subscription = Subscription.find(params[:subscription_id])
    @subscription.destroy
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def subscription_params
    params.require(:subscription).permit(:question_id)
  end
end
