Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    root :to => 'home#index'
    namespace :users do
      resource :detail, only: :show
      resources :winners, only: [:show, :update]
      resources :share,  only: [:show, :update]
      resources :feedbacks,  only: [:show, :index]
      resources :addresses, except: :show
      resources :lottery,  only: [:create, :show, :index ]

      resources :offers, only: :index do
        resources :orders, only: :create
      end

      scope :orders, as: :orders do
        put 'cancel/:id', as: :cancel, to: 'orders#cancel'
      end

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

      resources :users, constraints: { genre: /(increase|deduct|bonus)/ }, only: :index do
          get 'order/:genre/new', as: :new_order, to: 'orders#new'
          post 'order/:genre', as: :create_order, to: 'orders#create'
      end

      resources :winners, only: :index do
        put 'transition/:event', as: :transition, to: 'winners#transition'
      end

      resources :orders, only: :index do
        put 'cancel', to: 'orders#cancel'
        put 'pay', to: 'orders#pay'
      end

      resources :invite_list, as: :invites, only: :index

      resources :items, except: :show do
          put 'transition/:event', as: :transition, to: 'items#transition', constraints: lambda {|request| Item.aasm.events.map(&:name).include? (request.parameters[:event]) }
          put 'draw', to: 'items#draw'
      end

      resources :offers, except: :show

      resources :categories, except: :show

      resources :bet_list,  only: :index do
        put 'cancel', to: 'bet_list#cancel'
      end

      root to: 'dashboard#index'
    end
  end
end
