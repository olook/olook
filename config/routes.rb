# -*- encoding : utf-8 -*-
Olook::Application.routes.draw do
  get "index/index"
  root :to => "home#index"

  localized do
    match "/welcome", :to => "pages#welcome", :as => "welcome"
    resource :survey, :only => [:new, :create]

    get "member/invite" => "members#invite", :as => 'member_invite'
    get "invite/(:invite_token)" => 'members#accept_invitation', :as => "accept_invitation"
    post "member/invite_by_email" => 'members#invite_by_email', :as => 'member_invite_by_email'

    get "member/import_contacts" => "members#import_contacts", :as => 'member_import_contacts'
    post "member/import_contacts" => "members#show_imported_contacts", :as => 'member_show_imported_contacts'
    post "member/invite_contacts" => "members#invite_imported_contacts", :as => 'member_invite_imported_contacts'
  end

  namespace :admin do
    resources :products do
      resources :pictures
      resources :details
      resources :variants
    end
    match "/", :to => "index#dashboard"
  end

  devise_for :admins, :controllers => { :registrations => "registrations", :sessions => "sessions" } do
    post "after_sign_in_path_for", :to => "sessions#after_sign_in_path_for", :as => "after_sign_in_path_for_session"
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks", :registrations => "registrations", :sessions => "sessions" } do
    get '/users/auth/:provider' => 'omniauth_callbacks#passthru'
    post "after_sign_in_path_for", :to => "sessions#after_sign_in_path_for", :as => "after_sign_in_path_for_session"
  end
end
