# frozen_string_literal: true

require_relative 'controller_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer)   { create(:answer, question: question, user: @user) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer in the db' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }
          .to change(question.answers, :count).by(1)
      end

      it 'render create tamplate' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer in the db' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js } }
          .to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), user: @user, format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns the requested question to @question' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), user: @user, format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new body' },  user: @user, format: :js }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'render update template to update answer' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer),  user: @user, format: :js }
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #set_best' do
    sign_in_user

    context 'user is a author of question' do
      let(:question) { create(:question, user: @user) }

      it 'assigns the requested answer to @answer' do
        patch :set_best, params: { answer_id: answer, question_id: question, answer: attributes_for(:answer), user: @user, format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'setting answer as best' do
        expect(answer.best).to eq false
        patch :set_best, params: { answer_id: answer, question_id: question, answer: attributes_for(:answer), user: @user, format: :js }
        answer.reload
        expect(answer.best).to eq true
      end

      it 'render update template' do
        patch :set_best, params: { answer_id: answer, question_id: question, answer: attributes_for(:answer), user: @user, format: :js }
        expect(response).to render_template :set_best
      end
    end

    context 'user is not a author of question' do
      let!(:user2)    { create(:user) }
      let!(:question) { create(:question, user: user2) }

       it 'and can not set answer as best' do
         expect(answer.best).to eq false
         patch :set_best, params: { answer_id: answer, answer: attributes_for(:answer), user: @user, format: :js }
         answer.reload
         expect(answer.best).to eq false
       end
    end
  end


  describe 'DELETE #destroy' do
    sign_in_user
    before { answer }

    context 'answer of user' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer, format: :js } }
          .to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { question_id: question, id: answer, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'answer of somebody' do
      let(:answer) { create(:answer, question: question) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer, format: :js } }.to_not change(Answer, :count)
      end
    end
  end

  it_behaves_like 'votabled', 'answer'

end
