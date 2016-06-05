Rails.application.routes.draw do
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
      resource :profiles do
        get :me, on: :collection
        get :all, on: :collection
      end
    end
  end

  root to: "questions#index"
end
