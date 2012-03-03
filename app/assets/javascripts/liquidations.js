jQuery(function() {
  $("div#carousel_container ul").carouFredSel({
    auto: false,
    width: 380,
    items: 1,
    prev : {
      button : ".prev",
      items : 1
    },
    next : {
      button : ".next",
      items : 1
    }
  });

  $("form").bind("ajax:beforeSend", function(evt, xhr, settings) {
    $("#products").fadeOut("slow", function() {
      $(this).fadeIn("slow");
      $(this).html("");
    });
  });

  $('form').submit(function(){
    $(':submit', this).click(function() {
        return false;
    });
  });

  if ($('.pagination').length) {
    $(window).scroll(function() {
      var url;
      url = $('.pagination .next_page').attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 300) {
        $('.pagination').text("Buscando produtos");
        return $.getScript(url);
      }
    });
    return $(window).scroll();
  }
});

