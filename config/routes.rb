Rails.application.routes.draw do
  require 'sidekiq/web'
  authenticate :user, lambda{ |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  concern :votable do
    member  do
      post 'vote_up'
      post 'vote_down'
      delete 'delete_vote'
    end
  end

  resources :authorizations, only: [:new, :create]
  get 'confirm_auth', controller: :authorizations
  get 'resend_confirmation_email', controller: :authorizations

  resources :questions, concerns: :votable do
    resources :comments, only: :create, defaults: {commentable: 'questions'}

    resources :answers, only: [:new, :create, :update, :destroy], concerns: :votable, shallow: true do
      resources :comments, only: :create, defaults: {commentable: 'answers'}
      member do
        post 'make_best'
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, only: [:show, :index, :create] do
        resources :answers, only: [:show, :index, :create]
      end
    end
  end

  root to: "questions#index"
end
