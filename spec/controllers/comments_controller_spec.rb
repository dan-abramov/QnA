require_relative 'controller_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    let(:object) {create(:question)}
    sign_in_user

    context 'create comment to question' do
      it_behaves_like 'commentabled', 'question'
    end

    let(:object) {create(:answer)}
    sign_in_user
    
    context 'create comment to answer' do
      it_behaves_like 'commentabled', 'answer'
    end
  end
end
