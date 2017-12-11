# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    post '/confirm_email' => 'omniauth_callbacks#confirm_email'
  end

  concern :votable do
    member do
      post   :vote_up
      post   :vote_down
      delete :vote_reset
    end
  end

  resources :questions do
    concerns :votable
    resources :comments, shallow:true, only: [:create]
    resources :answers, shallow:true do
      concerns :votable
      resources :comments, shallow:true, only: [:create]
      patch :set_best
    end
    resources :subscriptions, shallow:true
  end

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions do
        resources :answers, shallow: true
      end
    end
  end

  resources :search, only: [:index]

  resources :attachments, only: [:destroy]
  root to: 'questions#index'

  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
