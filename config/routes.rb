Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    root :to => 'home#index'
    namespace :users do
      resource :detail, only: :show
      resources :addresses, except: :show
      get 'invite-people', to: 'invite_people#invite_page'
    end
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admin, path: '' do
      devise_for :users, controllers: { sessions: 'admin/sessions'}
      root to: 'dashboard#index'
    end
  end
end
