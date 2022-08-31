Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    root :to => 'home#index'
    namespace :users do
      resource :detail, only: :show
      resources :addresses, except: :show
      resources :lottery,  only: [:create, :show, :index ]

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
      resources :winners, only: :index do
        put 'transition/:event', as: :transition, to: 'winners#transition'
      end

      resources :items, except: :show do
        put 'transition/:event', as: :transition, to: 'items#transition'
        put 'draw', to: 'items#draw'
      end

      resources :categories, except: :show

      resources :bet_list,  only: :index do
        put 'cancel', to: 'bet_list#cancel'
      end

      root to: 'dashboard#index'
    end
  end
end
