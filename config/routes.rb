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
    delete :vote_reset, on: :member
  end

  concern :commentable do 
    post :add_comment, on: :member
  end

  resources :questions, concerns: [:votable], shallow: true do
    resources :answers, concerns: [:votable]
  end

  resources :questions, concerns: :commentable
  resources :answers, concerns: :commentable

  root to: "questions#index"

  resources :answers do 
    get :best, on: :member
  end

  resources :attachments, only: [:destroy]
end


