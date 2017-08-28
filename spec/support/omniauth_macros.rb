module OmniauthMacros
  def mock_auth_hash(provider)
  # The mock_auth configuration allows you to set per-provider (or default)
  # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
      'provider'  => provider.to_s,
      'uid'       => '123456',
      'user_info' => {
        'name'    => 'mockuser',
        'image'   => 'mock_user_thumbnail_url'
      },
      'credentials' => {
        'token'     => 'mock_token',
        'secret'    => 'mock_secret'
      }
    }.merge(provider == :twitter ? {info: {email: nil}} : {info: {email: 'some@email.com'}}))
  end
end
