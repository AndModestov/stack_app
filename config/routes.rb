Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  concern :votable do
    member  do
      post 'vote_up'
      post 'vote_down'
      delete 'delete_vote'
    end
  end


  resources :questions, concerns: :votable do
    resources :comments, only: :create, defaults: {commentable: 'questions'}

    resources :answers, only: [:new, :create, :update, :destroy], concerns: :votable, shallow: true do
      resources :comments, only: :create, defaults: {commentable: 'answers'}
      member do
        post 'make_best'
      end
    end
  end

  root to: "questions#index"
end
