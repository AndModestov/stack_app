require 'rails_helper'

describe 'Question API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 if there is no access_token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 if access_token is invalid' do
        get '/api/v1/questions', format: :json, access_token: '123456'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token){ create(:access_token) }
      let!(:questions){ create_list(:question, 2) }
      let(:question){ questions.first }
      let!(:answer){ create(:answer, question: question) }

      before do
        get '/api/v1/questions', format: :json, access_token: access_token.token
      end

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it 'question contains #{attr}' do
          question = questions.first
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json)
                                               .at_path("questions/0/#{attr}")
        end
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it 'contains #{attr}' do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json)
                                                 .at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do
    context 'unauthorized' do
      it 'returns 401 if there is no access_token' do
        get '/api/v1/questions/1', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 if access_token is invalid' do
        get '/api/v1/questions/1', format: :json, access_token: '123456'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token){ create(:access_token) }
      let!(:question){ create(:question) }
      let!(:comment){ create(:comment, commentable: question) }
      let!(:attachment){ create(:attachment, attachable: question) }

      before do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token
      end

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns question' do
        expect(response.body).to have_json_size(1)
      end

      %w(id title body created_at updated_at).each do |attr|
        it 'question contains #{attr}' do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json)
                                       .at_path("question/#{attr}")
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/comments")
        end

        %w(id body created_at updated_at user_id).each do |attr|
          it 'contains #{attr}' do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json)
                                         .at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/attachments")
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json)
                                       .at_path("question/attachments/0/url")
        end
      end
    end
  end

  describe 'POST #create' do
    context 'unauthorized' do
      it 'returns 401 if there is no access_token' do
        post '/api/v1/questions', format: :json, question: attributes_for(:question)
        expect(response.status).to eq 401
      end

      it 'returns 401 if access_token is invalid' do
        post '/api/v1/questions', format: :json, access_token: '123456', question: attributes_for(:question)
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token){ create(:access_token) }

      context 'with valid question data' do
        let(:post_valid_question) do
          post '/api/v1/questions', format: :json, access_token: access_token.token,
                                                   question: attributes_for(:question)
        end

        it 'returns 201 status' do
          post_valid_question
          expect(response).to be_success
        end

        it 'creates question' do
          expect{ post_valid_question }.to change(Question, :count).by(1)
        end
      end

      context 'with invalid question data' do
        let(:post_invalid_question) do
          post '/api/v1/questions', format: :json, access_token: access_token.token,
               question: attributes_for(:invalid_question)
        end

        it 'returns 422 status' do
          post_invalid_question
          expect(response).to_not be_success
        end

        it 'creates question' do
          expect{ post_invalid_question }.to_not change(Question, :count)
        end
      end
    end
  end
end