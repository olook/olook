jQuery(function() {
  if($("form#liquidation_filter input").is(":checked")) {
    setTimeout(function() {
      $("form#liquidation_filter").submit();
    }, 4000);
  }

  $("div#carousel_container ul").carouFredSel({
    width: 480,
    items: 1,
    auto : {
      pauseDuration : 15000
    },
    prev : {
      button : ".prev",
      key : "left",
      items : 1
    },
    next : {
      button : ".next",
      key : "right",
      items : 1
    }
  });

  $('#liquidation_order_filter').change(function() {
    $("#liquidation_filter").submit();
  });

  $("#liquidation_filter").find("input[type='checkbox'].select_all").live("click", function() {
      $(this).parents(".filter").find("input[type='checkbox']").not(".select_all").attr("checked", this.checked);
      var topHeight = 400;
      $("html, body").animate({
          scrollTop: topHeight
      }, 'slow');
      setTimeout(function() {
        $("#liquidation_filter").submit();
      }, 2500);
  });

  $('#liquidation_filter').submit(function() {
    $('#sort_filter').val($("#order_filter").find("option:selected").val());
    $("#products").fadeOut("slow", function() {
      $(".loading").show();
      $(this).fadeIn("slow");
      $(this).html("");
    });
  });

  $('#liquidation_filter').find("input[type='checkbox']").not(".select_all").click(function() {
    if(!$(this).is(":checked")) {
      $(this).parent().siblings("li").find("input[type='checkbox'].select_all").attr("checked", false);
    }
    $(this).parent().submit();
    $('#liquidation_filter').find("input[type='checkbox']").attr("disabled", "true");
    var topHeight = 400;
    $("html, body").animate({
      scrollTop: topHeight
    }, 'slow');
  });

  if ($('.pagination').length) {
    $(window).scroll(function() {
      var url;
      url = $('.pagination .next_page').attr('href');
      var bottomHeight = 580;
      var canPaginate =  url && ($(window).scrollTop() > $(document).height() - $(window).height() - bottomHeight) && !$('.loading').is(':visible');
      if (canPaginate) {
        $('.pagination .next_page').remove();
        $('#liquidation_filter').find("input[type='checkbox']").attr("disabled", "true");
        $('.loading').show();

        return $.getScript(url).done(function() {
          $('#liquidation_filter').find("input[type='checkbox']").removeAttr("disabled");
          $(".loading").hide();
        });
      }
    });
    return $(window).scroll();
  }
});

