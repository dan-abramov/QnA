require_relative 'controller_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  describe 'facebook' do
    it_behaves_like 'omniauthable', 'facebook'
  end

  describe 'vkontakte' do
    it_behaves_like 'omniauthable', 'vkontakte'
  end

  describe 'twitter' do
    let(:user) { create(:user) }

    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"]  = mock_auth_hash(:twitter)
    end

    context 'Application did get user-information from server' do
      before do
        request.env["omniauth.auth"] = nil
        get :twitter
      end

      it 'redirects to new_user_session_path' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'user did not log in' do
        expect(controller.current_user).to eq nil
      end
    end

    context 'Already registered user trying to sign in through twitter' do
      before do
        auth = mock_auth_hash(:twitter)
        authorization = create(:authorization, provider: auth.provider, uid: auth.uid, user: user )
        get :twitter
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to(root_path)
      end

      it 'user logged in' do
        expect(controller.current_user).to eq user
      end
    end

    context 'Did not registered user trying to register through twitter' do
      before do
        auth = mock_auth_hash(:twitter)
      end

      it 'redirects to confirm_email_path' do
        get :twitter
        expect(response).to render_template("omniauth_callback/confirm_email", "layouts/application")
      end

      it 'creates authorization' do
        expect { get :twitter }.to change(Authorization, :count).by(1)
      end
    end

    describe 'PATCH #confirm_email' do
      let(:user) { create(:user) }

      it 'assigns requested user to @user' do
        post :confirm_email, params: { user_id: user.id, email: { email: 'any@email.com' } }
        expect(assigns(:user)).to eq user
      end

      it 'updates email' do
        auth = mock_auth_hash(:twitter)
        post :confirm_email, params: { user_id: user.id, user: user, email: { email: 'new@email.com' } }
        user.reload
        expect(user.email).to eq 'new@email.com'
      end

      it 'redirects to root_path' do
        post :confirm_email, params: { user_id: user.id, user: user, email: { email: 'new@email.com' } }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
