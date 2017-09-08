# frozen_string_literal: true

Rails.application.routes.draw do
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
  end

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions
    end
  end

  resources :attachments, only: [:destroy]
  root to: 'questions#index'

  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
