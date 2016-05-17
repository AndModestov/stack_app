Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member  do
      post 'vote_up'
      post 'vote_down'
      delete 'delete_vote'
    end
  end

  resources :questions do
    resources :answers, only: [:new, :create, :update, :destroy], concerns: :votable, shallow: true do
      member do
        post 'make_best'
      end
    end
  end

  root to: "questions#index"
end
