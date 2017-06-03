# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer)   { create(:answer, question: question, user: @user) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer in the db' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }
          .to change(question.answers, :count).by(1)
      end

      it 'redirects to question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer in the db' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) } }
          .to_not change(Answer, :count)
      end

      it 'redirects to question' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    before { answer }

    context 'answer of user' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }
        .to change(Answer, :count).by(-1)
      end

      it 'redirects to queston' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'answer of somebody' do
      let(:answer)   { create(:answer, question: question) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }
        .to_not change(Answer, :count)
      end

      it 'redirects to queston' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
