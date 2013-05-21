// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var visualization_mode = "product";
function setMouseOverOnImages() {
   $('img.async').on("mouseenter", function () {
     var backside_image = $(this).attr('data-backside-picture');
     if(/http.*/.test(backside_image))
       $(this).attr('src', backside_image);
   }).on("mouseleave", function () {
     var field_name = 'data-' + visualization_mode;
     var showroom_image = $(this).attr(field_name);
     if(/http.*/.test(showroom_image))
       $(this).attr('src', showroom_image);
   });
};

perform_search = function() {
  _gaq.push(['_trackEvent', 'SearchBar', 'ClickSubmit']);
  returning_value = $("#search_product").val() == 'BUSCAR' ? false : true;
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
      $(this).val('BUSCAR')
    }
  });

  $("#search_product").autocomplete({
      source: "/search/product_suggestions",
      select: function(event, ui) { 
        $("input##search_product").val(ui.item.value);
        $("#search_form").submit();
      }
  });
  
});
