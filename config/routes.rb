Rails.application.routes.draw do

  root                        'sessions#new'
  post   'login'           => 'sessions#create'
  delete 'logout'          => 'sessions#destroy'

  resources :users
  resources :products

  resources :categories do
  	collection do
  		post 'bulk_action'
  	end
  end

end
