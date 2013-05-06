// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {

  $("#search_product").keypress(function(e) {
    if (e.which == 13) {
      $("form#search_form").submit();
      e.preventDefault();
      return false;
    }
  }).focus(function(){
    $(this).val('');
  }).focusout(function(){
    if($(this).val() == ''){
      $(this).val('BUSCAR')
    }
  });

  $("#search_product").autocomplete({
      source: "/search/product_suggestions"
  });

});
