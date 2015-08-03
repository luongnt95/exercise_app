Rails.application.routes.draw do

  root                        'sessions#new'
  post   'login'           => 'sessions#create'
  delete 'logout'          => 'sessions#destroy'

  resources :users
  resources :product_pictures, only: [:destroy]

  resources :categories do
  	collection do
  		post 'bulk_action'
  	end
  end

  resources :products do
    collection do
      post 'bulk_action'
    end
  end

end
