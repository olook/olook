$(function() {
  $("div#suggestion ul.product_actions li a").live("click", function(event) {
    InitSuggestion.clearSuggestions();
    event.preventDefault();
  });

  $("section#suggestions_container ul li.product div.hover_suggestive ul li.add a").live("click", function(event) {
    $(this).parent().fadeOut();
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
    InitSuggestion.showLinksToAdd();
    $("section#suggestions_container").slideDown("normal", function() {
      InitSuggestion.slideTo(this);
    });
  },

  hideSuggestiveProducts : function() {
    $("section#suggestions_container").slideUp();
  },

  showLinksToAdd : function() {
    $("section#suggestions_container ul li.product div.hover_suggestive ul li.add").show();
  },

  slideTo : function(local) {
    container_position = $(local).position().top;
    position = container_position + 60;
    $('html, body').animate({
      scrollTop: position
    }, 'slow');
  }
}
