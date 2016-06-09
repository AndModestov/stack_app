require 'rails_helper'

describe 'Answer API' do
  let(:question){ create(:question) }
  let!(:answer){ create(:answer, question: question) }
  let(:access_token){ create(:access_token) }

  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      before do
        do_request(access_token: access_token.token)
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

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:comment){ create(:comment, commentable: answer) }
      let!(:attachment){ create(:attachment, attachable: answer) }

      before do
        do_request(access_token: access_token.token)
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

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    it_behaves_like "API Authenticable"

    it_behaves_like "API creatable" do
      let(:object){ 'answer' }
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", { format: :json, answer: attributes_for(:answer) }.merge(options)
    end
  end
end