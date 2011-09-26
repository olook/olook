Olook::Application.routes.draw do
  root :to => "home#index"
  resources :survey, :only => [:index, :create]
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" } do
   get '/users/auth/:provider' => 'omniauth_callbacks#passthru'
  end
end
