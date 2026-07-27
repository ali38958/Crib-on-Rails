Rails.application.routes.draw do
  root to: 'login#index'
  get '/login', to: 'login#index'
  post '/login', to: 'login#create'
  post '/refresh', to: 'refresh#create'
  
  get '/logout', to: 'sessions#destroy'
  delete '/logout', to: 'sessions#destroy'
  
  get '/dashboard', to: 'dashboards#index'
  
  namespace :admin do
    get '/', to: 'dashboard#index'
    
    resources :users, only: [:index, :create, :update, :destroy] do
      member do
        get 'edit/:role', to: 'users#edit'
        patch ':role', to: 'users#update'
        delete ':role', to: 'users#destroy'
      end
      collection do
        get 'new/:role', to: 'users#new'
      end
    end
  end
  
  namespace :stock_manager do
    get '/', to: 'dashboard#index'
    resources :products, only: [:index, :new, :create, :edit, :update]
    resources :purchases, only: [:index, :new, :create]
    resources :categories, only: [:index, :new, :create, :edit, :update]
  end
  
  namespace :order_receiver do
    get '/', to: 'dashboard#index'
    resources :orders, only: [:index]
  end
end