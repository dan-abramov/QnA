require_relative 'controller_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    let(:question) {create(:question)}
    sign_in_user

    context 'create comment to question' do
      it 'saves the new comment in the db' do
        expect { post :create, params: { comment: { commentable_type: question.class.name,
                                                    commentable_id: question.id, body: 'Comment' },
                                                    question_id: question.id, format: :js} }.to change(Comment, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { comment: { commentable_type: question.class.name,
                                           commentable_id: question.id, body: 'Comment' },
                                           question_id: question.id, format: :js}
        expect(response).to render_template :create
      end

      it 'does not save the invalid comment in the db' do
        expect { post :create, params: { comment: { commentable_type: question.class.name,
                                                    commentable_id: question.id, body: '' },
                                                    question_id: question.id, format: :js} }.to change(Comment, :count).by(0)
      end
    end

    context 'create comment to answer' do
      let(:answer) {create(:answer)}

      it 'saves the new comment in the db' do
        expect { post :create, params: { comment: { commentable_type: answer.class.name,
                                                    commentable_id: answer.id, body: 'Comment' },
                                                    answer_id: answer.id, format: :js} }.to change(Comment, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { comment: { commentable_type: answer.class.name,
                                           commentable_id: answer.id, body: 'Comment' },
                                           answer_id: answer.id, format: :js}
        expect(response).to render_template :create
      end

      it 'does not save the invalid comment in the db' do
        expect { post :create, params: { comment: { commentable_type: answer.class.name,
                                                    commentable_id: answer.id, body: '' },
                                                    answer_id: answer.id, format: :js} }.to change(Comment, :count).by(0)
      end
    end
  end
end
