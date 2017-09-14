shared_examples_for 'omniauthable' do |social_network|
  let(:user) { create(:user) }

  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"]  = mock_auth_hash(social_network.to_sym)
  end

  context 'Application did get user-information from server' do
    before do
      request.env["omniauth.auth"] = nil
      get social_network.to_sym
    end

    it 'redirects to new_user_session_path' do
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'user did not log in' do
      expect(controller.current_user).to eq nil
    end
  end

  context 'Already registered user trying to sign in through social network' do
    before do
      auth = mock_auth_hash(social_network.to_sym)
      authorization = create(:authorization, provider: auth.provider, uid: auth.uid, user: user )
      get social_network.to_sym
    end

    it 'user logged in' do
      expect(controller.current_user).to eq user
    end

    it 'redirects to root_path' do
      expect(response).to redirect_to(root_path)
    end
  end

  context 'Did not registered user trying to register through social network' do
    before do
      auth = mock_auth_hash(social_network.to_sym)
    end

    it 'redirects to root_path' do
      get social_network.to_sym
      expect(response).to redirect_to(root_path)
    end

    it 'user registered' do
      expect { get social_network.to_sym }.to change(User, :count).by(1)
    end
  end
end
