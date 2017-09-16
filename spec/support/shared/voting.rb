shared_examples_for 'votabled' do |object_type|
  sign_in_user
  let(:object)      { create(object_type.to_sym) }

  describe 'Author voting for object of somebody' do
    context 'POST #vote_up' do
      it 'assigns the requested object to @votable' do
        post :vote_up, params: { id: object, format: :json }
        expect(assigns(:votable)).to eq object
      end


      it 'is voting up to object (can not do it more than 1 time)' do
        post :vote_up, params: { id: object, format: :json }
        post :vote_up, params: { id: object, format: :json }
        expect(object.rating).to eq 1
      end

      it 'returns JSON parse' do
        post :vote_up, params: { id: object, format: :json }
        json_parse = JSON.parse(response.body)
        expect(json_parse['rating']).to eq(1)
      end
    end

    context 'POST #vote_down' do
      it 'assigns the requested object to @votable' do
        post :vote_down, params: { id: object, format: :json }
        expect(assigns(:votable)).to eq object
      end


      it 'is voting down to object (can not do it more than 1 time)' do
        post :vote_down, params: { id: object, format: :json }
        post :vote_down, params: { id: object, format: :json }
        expect(object.rating).to eq -1
      end

      it 'returns JSON parse' do
        post :vote_down, params: { id: object, format: :json }
        json_parse = JSON.parse(response.body)
        expect(json_parse['rating']).to eq(-1)
      end
    end

    context 'POST #vote_reset' do
      it 'assigns the requested object to @votable' do
        post :vote_reset, params: { id: object, format: :json }
        expect(assigns(:votable)).to eq object
      end

      it 'is voting up to object' do
        post :vote_down, params: { id: object, format: :json }
        post :vote_reset, params: { id: object, format: :json }

        expect(object.rating).to eq 0
      end
    end
  end
  describe 'Author can not vote for his object' do
    let(:user)    { create(:user)}
    let(:object)  { create(object_type.to_sym, user: user) }
    before do
      sign_in user
    end

    context 'POST #vote_up' do
      it 'trying to vote up his object' do
        expect { post :vote_up, params: { id: object, format: :json } }.to change(Vote, :count).by(0)
      end
    end

    context 'POST #vote_down' do
      it 'trying to vote down to object' do
        expect { post :vote_down, params: { id: object, format: :json } }.to change(Vote, :count).by(0)
      end
    end

    context 'DELETE #vote_reset' do
      it 'trying to reset his choice (which was not)' do
        post :vote_down, params: { id: object, format: :json }
        expect(object.rating).to eq 0
        delete :vote_reset, params: { id: object, format: :json }
        expect(object.rating).to eq 0
      end
    end
  end
end
