Rails.application.routes.draw do

  root                        'sessions#new'
  post   'login'           => 'sessions#create'
  delete 'logout'          => 'sessions#destroy'

  resources :users
  resources :categories
  resources :products
end
