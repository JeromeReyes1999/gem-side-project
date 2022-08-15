Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    root :to => 'home#index'
    namespace :users do
      resource :detail, only: :show
      resources :addresses, except: :show
      get 'invite-people', to: 'invite_people#invite_page'

      # dependent select
      get 'get_provinces_by_region/:id', to: 'addresses#get_provinces_by_region'
      get 'get_cities_by_province/:id', to: 'addresses#get_cities_by_province'
      get 'get_barangays_by_city/:id', to: 'addresses#get_barangays_by_city'
    end
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admin, path: '' do
      devise_for :users, controllers: { sessions: 'admin/sessions'}
      resources :client_list, only: :index
      root to: 'dashboard#index'
    end
  end
end
