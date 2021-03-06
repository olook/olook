// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require common/if_console_log
//= require application_core/olook_app
//= require jquery_ujs
//= require ui/jquery.ui.core
//= require ui/jquery.ui.widget
//= require ui/jquery.ui.mouse
//= require ui/jquery.ui.position
//= require ui/jquery.ui.menu
//= require ui/jquery.ui.autocomplete
//= require ui/jquery.ui.slider
//= require common/jquery.cookie
//= require bamboo.0.1
//= require plugins/jquery.carouFredSel-6.2.1-packed
//= require plugins/css_browser_selector
//= require plugins/change_picture_onhover
//= require plugins/spy
//= require lite_base
//= require _search_bar
//= require ./partials/_credits_info
//= require plugins/footer_popup
//= require modules/facebook/events
//= require_tree ./modules/facebook/auth
//= require modules/facebook/auth
//= require modules/stats/facebook_stats_logger
//= require modules/modal/load
//= require modules/minicart/load

new FacebookAuth().config();
new FacebookStatsLogger().config();
$(function(){
  olookApp.publish('modal:request', document.location.pathname);
});
