Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, only: [:new, :create, :update, :destroy], shallow: true do
      member do
        post 'make_best'
      end
      member  do
        post 'vote_up'
        post 'vote_down'
        delete 'delete_vote'
      end
    end
  end

  root to: "questions#index"
end
