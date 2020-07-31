Rails.application.routes.draw do
  root 'reviews#index'

  get 'reviews/perform'

  resources :reviews, only: :update

  resources :words do
    resources :reviews, only: :create
    resources :definers, only: [:create, :destroy], module: 'words'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
