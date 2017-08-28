class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :check_auth, except: %i[confirm_email]

  def facebook
    authorization_through('Facebook')
  end

  def vkontakte
    authorization_through('Vkontakte')
  end

  def twitter
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if has_been_authorized_before(@user) && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      render template:'omniauth_callback/confirm_email', locals: { user: @user } if @user.persisted?
      @user.authorizations.create(provider: 'twitter', uid: @user.uid)
      sign_in(:user, @user)

      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    end
  end

  def confirm_email
    @user = User.find(params[:user_id])
    @user.update!(email)
    redirect_to root_path
  end

  private

  def email
    params.require(:email).permit(:email)
  end

  def has_been_authorized_before(user)
    Authorization.find_by uid: user.uid
  end

  def check_auth
    auth = request.env['omniauth.auth']
    if auth == nil
      redirect_to new_user_session_path
      flash[:notice] = 'Sorry, but we did not get information from your profile. Please, try to sign in later.'
    end
  end

  def authorization_through(social_network)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: social_network) if is_navigational_format?
    end
  end
end
