Olook::Application.routes.draw do
  root :to => "home#index"
  resources :survey, :only => [:index, :create]
end
