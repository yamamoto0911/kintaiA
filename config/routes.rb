Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/signup',   to: 'users#new'
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/edit-basic-info/:id', to: 'users#edit_basic_info', as: :basic_info
  patch 'update-basic-info', to: 'users#update_basic_info'
  get 'users/:id/attendances/:date/edit', to:'attendances#edit', as: :edit_attendances
  patch 'users/:id/attendances/:date/update', to: 'attendances#update', as: :update_attendances
  get '/attendance-users', to: 'users#attendance_users', as: :attendance_users
  
  resources :bases do
    member do
      get 'edit_base_info'
      patch 'update_base_info'
    end
  end
  resources :users do
    member do
      get 'edit_overwork_request_approval'
      patch 'update_overwork_request_approval'
      get 'edit_change_request_approval'
      patch 'update_change_request_approval'
      get 'edit_month_request_approval'
      patch 'update_month_request_approval'
      get 'working_log'
    end
    resources :attendances do
      member do
        get 'edit_overwork_request'
        patch 'update_overwork_request'
        patch 'update_month_request'
      end
    end
    collection { post :import }
  end
end