Rails.application.routes.draw do

  resources :wikis 

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "pages#home"
  get 'pages/home'


    devise_for :users, controllers: {
      sessions: 'users/sessions'
    }

end
