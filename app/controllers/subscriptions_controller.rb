class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  respond_to :js

  authorize_resource

  def create
    @subscription = current_user.subscriptions.create(subscription_params)
    @question = @subscription.question
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @question = @subscription.question
    @subscription.destroy if @subscription
  end

  private

  def subscription_params
    params.require(:subscription).permit(:question_id)
  end
end
