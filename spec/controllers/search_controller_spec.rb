require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    ['Everywhere', 'Questions', 'Answers', 'Comments', 'Users'].each do |object|
      it "searching in #{object}" do
        expect(Search).to receive(:find).with(object, 'test')
        get :index, params: { condition: object, search: 'test' }
      end

      it 'redirects to index' do
        get :index, params: { condition: object, search: 'test' }
        expect(response).to render_template :index
      end
    end
  end
end
