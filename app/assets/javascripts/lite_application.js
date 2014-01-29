// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery_ujs

//= require ./plugins/jquery.zoom-min
//= require ui/jquery.ui.core
//= require ui/jquery.ui.widget
//= require ui/jquery.ui.mouse
//= require ui/jquery.ui.position
//= require ui/jquery.ui.menu
//= require ui/jquery.ui.autocomplete
//= require ui/jquery.ui.slider
//= require plugins/jquery.carouFredSel-6.2.1-packed
//= require plugins/css_browser_selector
//= require plugins/change_picture_onhover
//= require common/product_view
//= require common/jquery.cookie
//= require application_core/olook_app
//= require lite_base
//= require _search_bar
//= require ./partials/_credits_info

$(document).ready(function() {
   $('a.sac').click(function(ev){
    window.open('http://olook.neoassist.com/?action=neolive&th=sac&scr=request&ForcaAutenticar=1',
    'Continue_to_Application','width=650,height=500');
    ev.preventDefault();
    return false;
  });
  $('a.moda').click(function(ev){
    window.open('http://olook.neoassist.com/?action=neolive&th=moda&scr=request&ForcaAutenticar=1',
    'Continue_to_Application','width=650,height=500');
    ev.preventDefault();
    return false;
  });
  $('a.email').click(function(ev){
    window.open('http://olook.neoassist.com/?action=new',
    'Continue_to_Application','width=650,height=700');
    ev.preventDefault();
    return false;
  });
  $('a.trade').click(function(ev){
    window.open('http://olook.neoassist.com/?th=troca&action=new',
    'Continue_to_Application','width=650,height=800,scrollbars=1');
    ev.preventDefault();
    return false;
  });
});
