require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:question) { create(:question) }
  let!(:user)     { create(:user) }

  before { sign_in user }

  describe 'POST #create' do
    it 'creates new subscription' do
      expect { post :create, params: { subscription: { question_id: question }, format: :js } }.to change(Subscription, :count).by(1)
    end
  end

  let(:subscription) { create(:subscription) }

  describe 'DELETE #destroy' do
    context 'subscription of user' do
      it 'deletes subscription' do
        sign_in(subscription.user)
        expect { delete :destroy, params: { id: subscription, format: :js } }.to change(Subscription, :count).by(-1)
      end
    end
  end
end
