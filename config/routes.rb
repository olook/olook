Olook::Application.routes.draw do
  devise_for :users

  root :to => "home#index"
  resources :survey, :only => [:index, :create]
end
