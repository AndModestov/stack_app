require 'rails_helper'

describe 'Question API' do
  let(:access_token){ create(:access_token) }

  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:questions){ create_list(:question, 2) }
      let(:question){ questions.first }
      let!(:answer){ create(:answer, question: question) }

      before do
        do_request(access_token: access_token.token)
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

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:question){ create(:question) }
    let!(:comment){ create(:comment, commentable: question) }
    let!(:attachment){ create(:attachment, attachable: question) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      before do
        do_request(access_token: access_token.token)
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

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    it_behaves_like "API Authenticable"

    it_behaves_like "API creatable" do
      let(:object){ 'question' }
    end

    def do_request(options = {})
      post '/api/v1/questions', { format: :json, question: attributes_for(:question) }.merge(options)
    end
  end
end