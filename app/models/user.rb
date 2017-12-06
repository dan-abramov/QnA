# frozen_string_literal: true

class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :comments
  has_many :authorizations
  has_many :subscriptions, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :vkontakte, :twitter]

  def author_of?(object)
    object.user_id == self.id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid:auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    if email == nil
      password = Devise.friendly_token[0, 20]
      email    = "#{Devise.friendly_token[0, 5]}@temporary-email.com"
      user     = User.create!(email: email, password: password, password_confirmation: password)
      user.update!(uid: auth.uid.to_s)
    else

      user = User.where(email: email).first
      if user
        user.create_authorization(auth)
      else
        password = Devise.friendly_token[0, 20]
        user = User.create!(email: email, password: password, password_confirmation: password)
        user.create_authorization(auth)
      end

    end
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
