Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'users/sessions' }
    root :to => 'home#index'
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admin, path: '' do
      devise_for :users, controllers: { sessions: 'admin/sessions' }
      root :to => 'dashboard#index'
    end
  end
end
