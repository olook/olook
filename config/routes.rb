Olook::Application.routes.draw do

  root :to => "home#index" 
  resources :survey, :only => [:index, :create]
  match "/welcome", :to => "pages#welcome", :as => "welcome" 

  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks", :registrations => "registrations" } do
    get '/users/auth/:provider' => 'omniauth_callbacks#passthru'
  end

end
