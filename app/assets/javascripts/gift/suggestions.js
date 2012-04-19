$(function() {
  $("div#suggestion ul.product_actions li a").live("click", function(event) {
    InitSuggestion.clearSuggestions();
    event.preventDefault();
  });
});

InitSuggestion = {
  clearSuggestions : function() {
    $("section#products div.product_container ul").fadeOut("normal", function() {
      $(this).html("");
      InitSuggestion.showSuggestiveProducts();
    });
  },

  showSuggestiveProducts : function() {
    $("section#suggestions_container").slideDown("normal", function() {
      InitSuggestion.slideToSuggestive();
    });
  },

  slideToSuggestive : function() {
    container_position = $("section#suggestions_container").position().top;
    position = container_position - 40;
    $('html, body').animate({
      scrollTop: position
    }, 'slow');
  }
}
