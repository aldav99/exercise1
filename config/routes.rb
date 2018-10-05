Rails.application.routes.draw do
  devise_for :users

  # unauthenticated do
  #   root :to => 'devise/sessions#new'
  # end

  # authenticated do
  #   root :to => 'questions#index'
  # end

  resources :questions, shallow: true do
    resources :answers
  end

  root to: "questions#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
