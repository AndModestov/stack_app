require 'rails_helper'

describe 'Answer API' do
  let(:question){ create(:question) }
  let!(:answer){ create(:answer, question: question) }
  let(:access_token){ create(:access_token) }

  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '123456'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns question answers list' do
        expect(response.body).to have_json_size(1).at_path("answers")
      end

      %w(id body created_at updated_at user_id).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    context 'unauthorized' do
      it 'returns 401 if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: '123456'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:comment){ create(:comment, commentable: answer) }
      let!(:attachment){ create(:attachment, attachable: answer) }

      before do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: access_token.token
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns answer' do
        expect(response.body).to have_json_size(1)
      end

      %w(id body created_at updated_at user_id).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        %w(id body created_at updated_at user_id).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/attachments")
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/url")
        end
      end
    end
  end
end