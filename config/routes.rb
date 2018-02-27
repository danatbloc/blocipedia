Rails.application.routes.draw do

  get 'admins/upgrade' 

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "pages#home"
  get 'pages/home'

  resources :charges, only: [:new, :create]

  resources :wikis

  resources :amounts, except: [:show]

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

end
