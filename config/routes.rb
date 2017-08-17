# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

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

  resources :attachments, only: [:destroy]
  root to: 'questions#index'

  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
