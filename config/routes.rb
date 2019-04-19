require 'sidekiq/web'


Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  
  # authenticate :user, lambda { |u| u.admin? } do
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do 
    post '/create_email' => 'omniauth_callbacks#create_email'
  end 

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

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
      end
      resources :questions, shallow: true do
        resources :answers
      end
    end
  end

  root to: "questions#index"


  resources :questions, shallow: true do
    resources :subscribers, only: [:create,:destroy]
  end

  resources :search, only: [:create]


  resources :answers do 
    get :best, on: :member
  end

  resources :attachments, only: [:destroy]
end


