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

  $('#liquidation_order_filter').change(function() {
    $("#liquidation_filter").submit();
  });

  $('#liquidation_filter').submit(function() {
    $('#sort_filter').val($("#order_filter").find("option:selected").val());
    $("#products").fadeOut("slow", function() {
      $(this).fadeIn("slow");
      $(this).html("");
    });
  });

  $('#liquidation_filter').find("input[type='checkbox']").click(function() {
    $(this).parent().submit();
  });

  if ($('.pagination').length) {
    $(window).scroll(function() {
      var url;
      url = $('.pagination .next_page').attr('href');
      var bottomHeight = 750
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - bottomHeight) {
        $('.pagination').text("Buscando produtos");
        return $.getScript(url);
      }
    });
    return $(window).scroll();
  }
});

