Rails.application.routes.draw do
  root to: redirect('/login')
  get '/login', to: 'login#index'
  post '/login', to: 'login#create'
  post '/refresh', to: 'refresh#create'
  
  get '/logout', to: 'sessions#destroy'
  delete '/logout', to: 'sessions#destroy'
  
  get '/forgot_password', to: 'login#forgot_password'
  post '/password_resets', to: 'password_resets#create'
  post '/password_resets/verify', to: 'password_resets#verify'
  post '/password_resets/update_password', to: 'password_resets#update_password'
  
  get '/dashboard', to: 'dashboards#index'

  namespace :admin do
    get '/', to: 'dashboard#index'
    resources :users, only: [:index, :new, :create, :edit, :update, :destroy] do
      member do
        get 'edit/:role', to: 'users#edit', as: 'edit_by_role'
        patch ':role', to: 'users#update'
        delete ':role', to: 'users#destroy'
      end
      collection do
        get 'new/:role', to: 'users#new', as: 'new_by_role'
        post 'create/:role', to: 'users#create', as: 'create_by_role'
      end
    end
    resources :orders, only: [:index] do
      collection do
        get 'export_csv'
      end
    end
      
    resources :stocks, only: [:index] do
      collection do
        get 'export_csv'
        get 'export_pdf'
      end
    end
  end
  
  namespace :stock_manager do
    get '/', to: 'dashboard#index'
    resources :suppliers, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :purchases, only: [:new, :create, :edit, :update, :destroy]  # No index
    resources :products, only: [:index, :new, :create, :edit, :update]
    resources :categories, only: [:index, :new, :create, :edit, :update]
  end
 
  # Order Receiver namespace
  namespace :order_receiver do
    get '/', to: 'dashboard#index'
    
    # Customer routes
    resources :customers, only: [:index, :new, :create, :edit, :update, :destroy]
    
    # Order routes
    get 'orders/launch', to: 'orders#launch', as: 'launch_orders'
    post 'orders/create_order', to: 'orders#create_order', as: 'create_order'
    
    resources :orders, only: [:index, :show, :edit, :update, :destroy] do
      member do
        patch 'update_status'
        patch 'cancel'
        patch 'update_price_paid'
      end
      collection do
        get 'launch', to: 'orders#launch'
        post 'create_order', to: 'orders#create_order'
      end
    end
    
    # Product routes (read-only)
    resources :products, only: [:index, :show]
  end
end