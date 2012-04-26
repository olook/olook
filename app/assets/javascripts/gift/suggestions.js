$(function() {
  $('#close_quick_view, div.overlay, a.add_product_to_suggestions').live("click", function() {
    $('#quick_view').fadeOut(300);
    $("div.overlay").remove();
  });

  $("a.add_product_to_suggestions").live("click", function() {
    relId = $(this).attr("rel");
    clazz = "a.add_suggestion_"+relId;
    $("a.add_suggestion_"+relId).parent().hide();
  });

  $("div#suggestion ul.product_actions li a.more_suggestions").live("click", function(event) {
    InitSuggestion.clearSuggestions();
    event.preventDefault();
  });

  $("section#suggestions_container ul li.product div.hover_suggestive ul li.add a").live("click", function(event) {
    $(this).parent().fadeOut();
    event.preventDefault();
  });

  $("div.box_product div.line ol li a.product_color").live("mouseenter", function() {
    productId = $(this).siblings(".product_id").val();
    hoverBox = $(this).parents("li.product").find(".hover_suggestive");
    spyLink = $(hoverBox).find("li.spy a").attr("href");
    addLink = $(hoverBox).find("li.add a").attr("href");
    $(hoverBox).find("li.spy a").attr("href", spyLink.replace(/\d+$/, productId));
    $(hoverBox).find("li.add a").attr("href", addLink.replace(/\d+$/, productId));
  });
});

InitSuggestion = {
  clearSuggestions : function() {
    $("section#products div.product_container ul").fadeOut("normal", function() {
      $(this).html("");
      InitSuggestion.showSuggestiveProducts();
    });
    $('li a.product_color').attr('data-remote', true);
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
