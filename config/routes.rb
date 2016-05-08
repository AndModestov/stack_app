Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, only: [:new, :create, :update, :destroy] do
      member do
        post 'make_best'
      end
    end
  end

  root to: "questions#index"
end
