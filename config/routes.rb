Rails.application.routes.draw do
  devise_for :users

  # unauthenticated do
  #   root :to => 'devise/sessions#new'
  # end

  # authenticated do
  #   root :to => 'questions#index'
  # end

  # concern :votable do
  #   resources :votes
  # end

  concern :votable do 
    post :vote_up, on: :member
    post :vote_down, on: :member
    post :vote_reset, on: :member
    # delete :vote_reset, on: :member
  end

  resources :questions, concerns: [:votable], shallow: true do
    resources :answers, concerns: [:votable]
  end

  # resources :questions, shallow: true do
  #   resources :answers
  # end

  root to: "questions#index"

  # post "best" => "answers#make_best"
  resources :answers do 
    get :best, on: :member
  end

  resources :attachments, only: [:destroy]

  # post 'best', to: 'answers#make_best'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end


