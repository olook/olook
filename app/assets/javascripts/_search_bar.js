if(!olook) var olook = {};
olook.perform_search = function() {
  var term = $(".search_product:visible").val();
  _gaq.push(['_trackEvent', 'SearchBar', 'ClickSubmit', term]);
  returning_value = term == '' ? false : true;
  return returning_value;
};

$(function() {
  $(".search_product").click(function(e){
    this.value = "";
    $(this).removeClass('default').addClass('enabled');
  });

  $(".search_product").keypress(function(e) {
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
        $("input.search_product").val(ui.item.value);
        $(".search_form").submit();
      }
  }).parents('form').submit(olook.perform_search);

  var num = 37;
  $(window).bind('scroll', function () {
    var element = $('.fixed_filter')[0];
    var top = element.getBoundingClientRect().top;
    if (top <= num) {
      $('.fixed_filter').addClass('js_fixed');
    } else {
      $('.fixed_filter').removeClass('js_fixed');
    }
  });

});
