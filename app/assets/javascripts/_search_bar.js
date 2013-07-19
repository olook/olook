if(!olook) var olook = {};
olook.perform_search = function() {
  var term = $("#search_product").val(); 
  _gaq.push(['_trackEvent', 'SearchBar', 'ClickSubmit', term]);
  returning_value = term == '' ? false : true;
  return returning_value;
};

$(function() {
  $("#search_product").keypress(function(e) {
    if (e.which == 13) {
      $(this).parents('form').submit();
      e.preventDefault();
      return false;
    }
  }).focus(function(){
    $(this).val('');
  }).autocomplete({
      source: "/busca/product_suggestions",
      select: function(event, ui) { 
        $("input##search_product").val(ui.item.value);
        $("#search_form").submit();
      }
  }).parents('form').submit(olook.perform_search);
  
});
