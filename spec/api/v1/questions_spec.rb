require_relative '../../controllers/controller_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unathorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token)   { create(:access_token) }
      let!(:questions)     { create_list(:question, 2) }
      let(:question)       { questions.first }
      let!(:answer)        { create(:answer, question: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          question = questions.first
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("0/short_title")
      end

      context 'answers' do
        it 'include in question object' do
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            question = questions.first
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end
  end



  describe 'GET /show' do
    context 'unathorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token)   { create(:access_token) }
      let(:question)       { create(:question) }
      let!(:answers)       { create_list(:answer, 2, question: question) }
      let(:attachments)     { create_list(:attachment, 2, attachable: question) }

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns question' do
        expect(response.body).to have_json_size(1)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("0/short_title")
      end

      context 'answers' do
        it 'include in question object' do
          expect(response.body).to have_json_size(2).at_path("0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            answer = answers.first
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end

        context 'comments' do
          let(:user)     { create(:user) }
          let(:comments) { create_list(:comment, 2, commentable: question, user: user) }

          it 'include in question object' do
            expect(response.body).to have_json_size(2).at_path("0/comments")
          end

          %w(id body created_at updated_at).each do |attr|
            it "contains #{attr}" do
              comment = comments.first
              expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
            end
          end
        end

        context 'attachments' do
          it 'include in question object' do
            expect(response.body).to have_json_size(2).at_path("0/attachments")
          end

          %w(id body created_at updated_at).each do |attr|
            it "contains #{attr}" do
              attachment = attachments.first
              expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("0/attachment/0/#{attr}")
            end
          end
        end
      end
    end
  end
end
