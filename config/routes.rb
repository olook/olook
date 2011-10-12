# -*- encoding : utf-8 -*-
Olook::Application.routes.draw do

  get "index/index"

  root :to => "home#index"
  resources :survey, :only => [:index, :create]
  match "/welcome", :to => "pages#welcome", :as => "welcome"

  namespace :admin do
    #resources :index, :only => [:index]
    match "/", :to => "index#dashboard"
  end

  devise_for :admins
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks", :registrations => "registrations", :sessions => "sessions" } do
    get '/users/auth/:provider' => 'omniauth_callbacks#passthru'
    post "after_sign_in_path_for", :to => "sessions#after_sign_in_path_for", :as => "after_sign_in_path_for_session"
  end

  get "member/invite" => "member#invite"
  get "invite/(:invite_token)" => 'member#accept_invitation', :as => "accept_invitation"
  post "member/invite_by_email" => 'member#invite_by_email'

  get "member/import_contacts" => "member#import_contacts"
  post "member/import_contacts" => "member#show_imported_contacts"
  post "member/invite_contacts" => "member#invite_imported_contacts"
end
