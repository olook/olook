# -*- encoding : utf-8 -*-
Olook::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true
  config.assets.css_compressor = :yui
  config.assets.js_compressor = :uglifier

  # Fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  #config.logger = SyslogLogger.new('rails-olook-prod')

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store
  config.cache_store = :dalli_store, 'appcache.o2ltwu.0001.use1.cache.amazonaws.com',{ :namespace => 'olook', :expires_in => 15.minutes, :compress => true }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = Proc.new do |source, request|
  #   request.ssl? ? "https://cdn-app.olook.com.br.s3.amazonaws.com" : "http://cdn-app.olook.com.br.s3.amazonaws.com"
  # end

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )
  config.assets.precompile += %w(
    *.js
    admin/*.js
    admin/bootstrap.js
    admin/credit.js
    admin/jquery.miniColors.js
    admin/liquidation_products.js
    admin/lookbook_image_map.js
    admin/coupons.js
    admin/index.js
    admin/jquery.validate.min.js
    admin/lookbook_autocomplete.js
    admin/lookbooks.js

    common/*.js
    common/base.js
    common/jquery.zclip.min.js
    common/jquery.cookie.js
    common/product_view.js

    gift/*.js
    gift/occasions.js
    gift/recipients.js
    gift/suggestions.js
    gift/survey.js

    plugins/*.js
    plugins/auto-grow-input.js
    plugins/jcarousel.min.js
    plugins/jquery.meio.mask.js
    plugins/css_browser_selector.js
    plugins/jquery.hotkeys.js
    plugins/jquery.slideto.js
    plugins/jail.min.js
    plugins/jquery.jqzoom-core.js
    plugins/styleSelect.min.js
    plugins/carouFredSel-5.4.1/jquery.carouFredSel-5.4.1.js
    plugins/jscrollpane/jquery.jscrollpane.min.js
    plugins/jscrollpane/jquery.mousewheel.js

    ui/*.js
    ui/jquery.ui.core.min.js
    ui/jquery.ui.position.min.js
    ui/jquery.ui.dialog.min.js
    ui/jquery.ui.widget.min.js

    section/*.css
    section/checkout.css
    section/error.css
    section/gift_home.css
    section/how_to.css
    section/liquidations.css
    section/my_account.css   
    section/register.css
    section/suggestions.css
    section/welcome.css
    section/contact.css
    section/friends.css
    section/half_user.css
    section/invite.css
    section/lookbooks.css
    section/pages.css
    section/showroom.css
    section/survey.css
    section/delivery.css
    section/gift.css
    section/home.css
    section/landing.css
    section/moments.css
    section/product.css
    section/stylists.css
    section/valentine.css
  )

  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.raise_delivery_errors = true

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

end
