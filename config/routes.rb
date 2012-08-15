require 'resque/server'

# -*- encoding : utf-8 -*-
Olook::Application.routes.draw do
  get "settings/index"

  get "settings/update"

  mount Resque::Server => "/admin/resque"

  root :to => "home#index"
  get "/quiz", :to => "home#index"
  get "home/index"
  get "index/index"

  match '/404', :to => "application#render_public_exception"
  match '/500', :to => "application#render_public_exception"
  match "/home", :to => "home#index"
  match "/sobre", :to => "pages#about", :as => "about"
  match "/termos", :to => "pages#terms", :as => "terms"
  match "/faq", :to => "pages#faq", :as => "faq"
  match "/devolucoes", :to => "pages#return_policy", :as => "return_policy"
  match "/privacidade", :to => "pages#privacy", :as => "privacy"
  match "/prazo-de-entrega", :to => "pages#delivery_time", :as => "delivery_time"
  match "/como-funciona", :to => "pages#how_to", :as => "how_to"
  match "/olook-na-imprensa", :to => "pages#press", :as => "press"
  match "/stylists/helena-linhares", :to => "stylists#helena_linhares", :as => "helena_linhares"
  get   "/contato" => "pages#contact", :as => "contact"
  post  "/contato" => "pages#send_contact", :as => "send_contact"

  #LOOKBOOKS
  match "/lookbooks/:name", :to => "lookbooks#show"
  match "/lookbooks", :to => "lookbooks#show", :as => "lookbooks"

  #LIQUIDATIONS
  get "/olooklet/:id" => "liquidations#show", :as => "liquidations"
  get '/update_liquidation', :to => "liquidations#update", :as => "update_liquidation"

  #MOMENTS
  get '/moments', to: "moments#index", as: "moments"
  get '/moments/:id', to: "moments#show", as: "moment"
  get '/update_moment', to: "moments#update", as: "update_moment"

  #FRIENDS
  match "/membro/:share/:uid", :to => "home#index"
  match "/minhas-amigas/conectar", :to => "friends#facebook_connect", :as => "facebook_connect"
  match "/minhas-amigas/home", :to => "friends#home", :as => "friends_home"
  match "/minhas-amigas/vitrine/:friend_id", :to => "friends#showroom", :as => "friend_showroom"
  get "/minhas-amigas/atualizar-lista-amigas", :to => "friends#update_friends_list", :as => "update_friends_list"
  get "/minhas-amigas/atualizar-quiz", :to => "friends#update_survey_question", :as => "update_survey_question"
  post "/postar-no-mural", :to => "friends#post_wall", :as => "post_wall"
  post "/postar-resposta-quiz", :to => "friends#post_survey_answer", :as => "post_survey_answer"
  post "/postar-convite", :to => "friends#post_invite", :as => "post_invite"

  #XML FOR STATISTICS
  match "/criteo", :to => "xml#criteo", :as => "criteo", :defaults => { :format => 'xml' }
  match "/mt_performance", :to => "xml#mt_performance", :as => "mt_performance", :defaults => { :format => 'xml' }
  match "/click_a_porter", :to => "xml#click_a_porter", :as => "click_a_porter", :defaults => { :format => 'xml' }
  match "/adroll", :to => "xml#adroll", :as => "adroll", :defaults => { :format => 'xml' }

  #SURVEY
  resource :survey, :only => [:new, :create], :path => 'quiz', :controller => :survey
  get "/survey/check_date", :to => "survey#check_date", :as => "check_date"

  #PRODUCT
  get "/produto/:id" => "product#show", :as => "product"

  #VITRINE / INVITE
  get "membro/convite" => "members#invite", :as => 'member_invite'
  # TODO: Remove later namorado
  get "membro/convite_namorado" => "members#valentine_invite", :as => 'member_valentine_invite'
  get "convite/(:invite_token)" => 'members#accept_invitation', :as => "accept_invitation"
  # TODO: Remove later namorado
  post "membro/convite_namorado_por_email" => 'members#valentine_invite_by_email', :as => 'member_valentine_invite_by_email'
  post "membro/convite_por_email" => 'members#invite_by_email', :as => 'member_invite_by_email'
  post "membro/novo_usuario_convite_por_email" => 'members#new_member_invite_by_email', :as => 'new_member_invite_by_email'
  get "membro/importar_contatos" => "members#import_contacts", :as => 'member_import_contacts'
  post "membro/importar_contatos" => 'members#show_imported_contacts', :as => 'member_show_imported_contacts'
  post "membro/convidar_contatos" => "members#invite_imported_contacts", :as => 'member_invite_imported_contacts'
  get "membro/convidadas" => "members#invite_list", :as => 'member_invite_list'
  get "membro/vitrine", :to => "members#showroom", :as => "member_showroom"
  get "membro/vitrine_shoes", :to => "members#showroom_shoes", :as => "member_showroom_shoes"
  get "membro/vitrine_bags", :to => "members#showroom_bags", :as => "member_showroom_bags"
  get "membro/vitrine_accessories", :to => "members#showroom_accessories", :as => "member_showroom_accessories"
  get "membro/bem-vinda", :to => "members#welcome", :as => "member_welcome"
  get "membro/creditos", :to => "members#credits", :as => "member_credits"
  post "user_liquidations", :controller => "user_liquidations", :action => "update"
  post "user_notifications", :controller => "user_liquidations", :action => "notification_update"

  # GIFT
  namespace :gift do
    root :to => "home#index"
    get "update_birthdays_by_month/:month" => "home#update_birthdays_by_month"
    resource :survey, :only => [:new, :create], :path => 'quiz', :controller => :survey
    resources :recipients do
      resources :suggestions, :only => [:index]
      post "suggestions/add_to_cart" => "suggestions#add_to_cart", :as => :add_suggestions_to_cart
      get "suggestions/select_gift/:product_id" => "suggestions#select_gift"
      post "suggestions/select_gift/" => "suggestions#select_gift"
      member do
        get :edit
        put :edit
        put :update
      end
    end
    resources :occasions, :only => [:new, :create] do
      collection do
        post "new_with_data" => "occasions#new_with_data"
      end
    end
  end

  #ADMIN
  devise_for :admins

  namespace :admin do
    match "/", :to => "index#dashboard"

    get 'product_autocomplete' => 'products#autocomplete_information'
    resources :products do
      collection do
        post 'sync_products' => 'products#sync_products', :as => 'sync_products'
      end

      resources :pictures do
        collection do
          get  'multiple_pictures' => 'pictures#new_multiple_pictures', :as => 'new_multiple_pictures'
          post 'multiple_pictures' => 'pictures#create_multiple_pictures', :as => 'create_multiple_pictures'
        end
      end
      resources :details
      resources :variants
      member do
        post 'add_related' => "products#add_related", :as => "add_related"
        delete 'remove_related/:related_product_id' => "products#remove_related", :as => "remove_related"
      end
    end

    resources :lookbooks do
      resources :images do
        resources :lookbook_image_maps
      end
      get :products, :to => "lookbooks#product"
    end

    resources :moments

    resources :users, :except => [:create, :new] do
      collection do
        get 'statistics' => 'users#statistics', :as => 'statistics'
        get 'export' => 'users#export', :as => 'export'
        get 'login/:id' => 'users#admin_login'
        get 'lock_access/:id' => 'users#lock_access'
        get 'unlock_access/:id' => 'users#unlock_access'
        post 'create_credit_transaction' => 'users#create_credit_transaction'
      end
    end

    resources :utilities do
      collection do
        post 'restart_resque_workers' => "utilities#restart_resque_workers", :as => "restart_resque_workers"
        post 'invalidates_cdn_content' => "utilities#invalidates_cdn_content", :as => "invalidates_cdn_content"
      end
    end
    resources :shipping_services
    resources :collections do
      get 'mark_all_products_as_visible' => 'collections#mark_all_products_as_visible', as: 'display_products'
      get 'mark_all_products_as_invisible' => 'collections#mark_all_products_as_invisible', as: 'hide_products'
    end

    post 'integrate_orders' => "orders#integrate_orders"
    post 'integrate_cancel' => "orders#integrate_cancel"
    post 'integrate_payment' => "orders#integrate_payment"
        
    resources :orders do
      collection do
        get 'timeline/:id' => 'orders#generate_purchase_timeline'
      end
    end
    resources :coupons, :except => [:destroy]
    resources :landing_pages
    resources :promotions
    resources :liquidations do
      resources :liquidation_carousels, :as => "carousels" do
        collection do
          put "/" => "liquidation_carousels#update"
        end
      end
      get 'fetch' => "liquidations#fetch", :as => "fetch"
      resources :liquidation_carousels, :as => "carousels"
      resources :liquidation_products, :as => "products"
    end
    resources :roles do
      resources :permissions
    end
    resources :admins

    resources :gift_occasion_types
    resources :gift_recipient_relations
    resource :settings
    
  end

  #USER / SIGN IN

  devise_for :users, :path => 'conta', :controllers => { :omniauth_callbacks => "omniauth_callbacks", :registrations => "users/registrations", :sessions => "users/sessions" } do
    get '/entrar' => 'users/sessions#new', :as => :new_user_session
    post '/entrar' => 'users/sessions#create', :as => :user_session
    delete '/logout' => 'users/sessions#destroy', :as => :destroy_user_session
    get '/registrar' => "users/registrations#new_half", :as => :new_half_user_session
    post '/registrar' => "users/registrations#create_half", :as => :create_half_user
    get '/users/auth/:provider' => 'omniauth_callbacks#passthru'
    delete '/conta/remover_facebook' => 'users/registrations#destroy_facebook_account', :as => :destroy_facebook_account
  end

  get '/conta/pedidos/:number', :controller =>'users/orders', :action => 'show' , :as => "user_order"
  namespace :users, :path => 'conta', :as => "user" do
    resources :addresses, :path => 'enderecos'
    resources :orders, :path => 'pedidos', :only => [:index]
    resources :credits, :path => 'creditos' do
      collection do
        post 'creditos/reenviar_convite/:id' => 'credits#resubmit_invite', :as => :resubmit_invite
        post 'creditos/reenviar_todos' => 'credits#resubmit_all_invites', :as => :resubmit_all_invites
      end
    end
  end

  #CHECKOUT
  resource :cart, :path => 'sacola', :controller => "checkout/cart" do
    get "update_status" => "checkout/cart#update_status", :as => :update_status
    put "update_gift_wrap" => "checkout/cart#update_gift_wrap", :as => :update_gift_wrap
    put "update_credits" => "checkout/cart#update_credits", :as => :update_credits
    delete "remove_credits" => "checkout/cart#remove_credits", :as => :remove_credits
    put "update_coupon" => "checkout/cart#update_coupon", :as => :update_coupon
    delete "remove_coupon" => "checkout/cart#remove_coupon", :as => :remove_coupon

    resource :checkout, :path => 'pagamento', :controller => 'checkout/checkout' do
      get "preview_by_zipcode", :to => "checkout/addresses#preview", :as => :preview_zipcode
      resources :addresses, :path => 'endereco', :controller => "checkout/addresses" do
        get "assign_address", :to => "checkout/addresses#assign_address", :as => :assign_address
      end

      get "boleto", :to => "checkout/checkout#new_billet", :as => :new_billet
      post "boleto", :to => "checkout/checkout#create_billet", :as => :billet
      get "credito", :to => "checkout/checkout#new_credit_card", :as => :new_credit_card
      post "credito", :to => "checkout/checkout#create_credit_card", :as => :credit_card
      get "debito", :to => "checkout/checkout#new_debit", :as => :new_debit
      post "debito", :to => "checkout/checkout#create_debit", :as => :debit
    end
  end

  #FINISH
  get '/pedido/:number', :to =>'checkout/orders#show', :as => :order_show

  #MOIP-CALLBACK
  post '/pagamento', :to => 'checkout/payments#create', :as => :payment

  #ZIPCODE
  get "/get_address_by_zipcode", :to => "zipcode_lookup#get_address_by_zipcode"

  get '/l/:page_url', :controller =>'landing_pages', :action => 'show' , :as => 'landing'
  get ":page_url", :to => "landing_pages#show"
end
