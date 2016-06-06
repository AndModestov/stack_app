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
end