Olook::Application.routes.draw do
  resources :survey, :only => [:index, :create]

end
