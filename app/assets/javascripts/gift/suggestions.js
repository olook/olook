$(function() {
  initSuggestion.disableDefaultProducts();

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
    initSuggestion.clearSuggestions();
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

  $("div.product_container ul li.product a.delete").live("click", function(e) {
    e.preventDefault();
    if($("section#suggestions_container").is(":hidden")) {
      $("section#suggestions_container").slideDown();
    }
    productContainer = $(this).parents("div.product_container");
    nextContainer = $(productContainer).next();
    productId = $(this).parent().find("input[type='hidden']").val();

    initSuggestion.unblockProduct(productId);
    $(this).parent("li.product").fadeOut("normal", function() {
      $(productContainer).find("ul").html("");
    });

    initSuggestion.checkProductOnContainer(nextContainer);
  });
});

initSuggestion = {
  disableDefaultProducts : function() {
    $("div.product_container").each(function() {
      id = $(this).find("ul li input[type='hidden']").val();
      $("a.add_suggestion_"+id).parent().hide();
    });
  },

  unblockProduct : function(id) {
    $("a.add_suggestion_"+id).parent().show();
  },

  checkProductOnContainer : function(container) {
    if($(container).find("ul").html() != "") {
      initSuggestion.repositionProduct(container);
    } else {
      return false;
    }
  },

  repositionProduct : function(container) {
    nextContainer = $(container).next();
    $(container).find("ul").find("li.product").fadeOut("normal", function() {
      $(this).parent().html("");

      productId = $(this).find("input[type='hidden']").val();
      $.ajax({
        type: "GET",
        dataType: 'script',
        url: window.location.pathname + "/select_gift/" + productId
      }).done(function(data) {
        initSuggestion.checkProductOnContainer(nextContainer);
      });
    });
  },

  clearSuggestions : function() {
    $("section#products div.product_container ul").fadeOut("normal", function() {
      $(this).html("");
      initSuggestion.showSuggestiveProducts();
    });
    $('li a.product_color').attr('data-remote', true);
  },

  showSuggestiveProducts : function() {
    initSuggestion.showLinksToAdd();
    $("section#suggestions_container").slideDown("normal", function() {
      initSuggestion.slideTo(this);
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
  },

  checkIfProductIsAlreadySelected : function() {
    productBox = $("div#quick_view").find("div#product");
    productId = $(productBox).attr("class").split("_")[1];
    $("section#products div.product_container").each(function() {
      boxProductId = $(this).find("ul").find("li").find("input[type='hidden']").val();
      if(productId == boxProductId) {
        link = $(productBox).find("a.add_product_to_suggestions");
        $(link).css('visibility','hidden');
        $(link).bind('click', false);
        return false;
      }
    });
  }
}
