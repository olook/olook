// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var visualization_mode = "product";
function setMouseOverOnImages() {
   $('img.async').on("mouseenter", function () {
     var backside_image = $(this).attr('data-backside-picture');
     $(this).attr('src', backside_image);
   }).on("mouseleave", function () {
     var field_name = 'data-' + visualization_mode;
     var showroom_image = $(this).attr(field_name);
     $(this).attr('src', showroom_image);
   });
};

perform_search = function() {
  var term = $("#search_product").val(); 
  _gaq.push(['_trackEvent', 'SearchBar', 'ClickSubmit', term]);
  returning_value = term == '' ? false : true;
  return returning_value;
};


$(function() {
  setMouseOverOnImages();
  
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
      $(this).val('')
    }
  });

  $("#search_product").autocomplete({
      source: "/busca/product_suggestions",
      select: function(event, ui) { 
        $("input##search_product").val(ui.item.value);
        $("#search_form").submit();
      }
  });
  
});
