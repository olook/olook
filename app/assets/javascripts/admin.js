// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree ./plugins
//= require_tree ./common
//= require_tree ../../../vendor/assets/javascripts/ui-v1.10.4
//= require_tree ./admin
$(function() {
  $("#search_custom_cpf_finder").setMask("999.999.999-99")
  $("#search_cnpj_contains").setMask("99.999.999/9999-99")
  $("#brand_bg_color, #brand_font_color, #collection_theme_bg_color, #collection_theme_font_color").colpick({
    layout:'hex',
    submit:0,
    colorScheme:'dark',
    onChange:function(hsb,hex,rgb,el,bySetColor) {
      $(el).css('border-color','#'+hex);
      if(!bySetColor) $(el).val(hex);
	  }
  }).keyup(function(){
    $(this).colpickSetColor(this.value);
  });
});


