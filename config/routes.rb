Rails.application.routes.draw do

  root               'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :product_pictures, only: [:destroy]


  resources :users, except: [:show] do
    collection do
      post 'bulk_action'
    end
  end

  resources :categories, except: [:show] do
  	collection do
  		post 'bulk_action'
  	end
  end

  resources :products, except: [:show] do
    collection do
      post 'bulk_action'
    end
  end

  get '*unmatched_route' => 'application#raise_not_found'

end
