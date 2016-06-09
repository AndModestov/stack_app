shared_examples_for "API creatable" do
  context 'authorized' do
    context 'with valid question data' do
      let(:post_valid_object) do
        do_request(access_token: access_token.token)
      end

      it 'returns 201 status' do
        post_valid_object
        expect(response).to be_success
      end

      it 'creates object' do
        expect{ post_valid_object }.to change(object.classify.constantize, :count).by(1)
      end
    end

    context 'with invalid question data' do
      let(:post_invalid_object) do
        do_request(access_token: access_token.token, "#{object}".to_sym => attributes_for("invalid_#{object}".to_sym))
      end

      it 'returns 422 status' do
        post_invalid_object
        expect(response).to_not be_success
      end

      it 'does not create question' do
        expect{ post_invalid_object }.to_not change(object.classify.constantize, :count)
      end
    end
  end
end