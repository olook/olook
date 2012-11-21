jQuery(function() {

  $('form#filter').submit(function() {
    $('.loading').show();
    $('#sort_filter').val($("#order_filter").find("option:selected").val());
    $("#products").fadeOut("slow", function() {
      $(this).fadeIn("slow");
      $(this).html("");
    });
    initLiquidation.scrollToList();
  });

  if($("form#filter input").is(":checked")) {
    $("form#filter").submit();
  }

  $("html").live("click", function() {
    $("div#products_container div#s)oe_size_filter div.sizes").hide();
  });

  $("div#products_container div#shoe_size_filter span").live("click", function(e) {
    $(this).siblings(".sizes").toggle();
    e.stopPropagation();
  });

  $("div#products_container div#shoe_size_filter div.sizes input").change(function(e) {
    checked = $(this).is(":checked");
    val = $(this).val();
    filterSize = $("form#filter div.filter #"+val);
    textSize = "";
    if(checked == true) {
      $(filterSize).attr("checked", true);
    } else {
      $(filterSize).attr("checked", false);
    }
    checkedSize = $("div#shoe_size_filter div.sizes input:checked").size();
    $("div#shoe_size_filter div.sizes input:checked").each(function(index) {
      if(checkedSize == 1) {
        $("div#products_container div#shoe_size_filter span").text($(this).val());
      } else {
        if(index == 0) {
          textSize = $(this).val();
        } else {
          textSize = textSize + ", " + $(this).val();
        }
        $("div#products_container div#shoe_size_filter span").text(textSize);
      }
    });
    $(filterSize).click();
  });

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

  $('#order_filter form').change(function() {
    $("form#filter").submit();
  });

  $("form#filter").find("input[type='checkbox'].select_all").live("click", function() {
      $(this).parents(".filter").find("input[type='checkbox']").not(".select_all").attr("checked", this.checked);
      var topHeight = 400;
      $("html, body").animate({
          scrollTop: topHeight
      }, 'slow');
      setTimeout(function() {
        $("form#filter").submit();
      }, 2500);
  });

  $('form#filter').find("input[type='checkbox']").not(".select_all").click(function() {
    if(!$(this).is(":checked")) {
      $(this).parent().siblings("li").find("input[type='checkbox'].select_all").attr("checked", false);
    }
    $(this).parent().submit();
    $('form#filter').find("input[type='checkbox']").attr("disabled", "true");
    var topHeight = 400;
    $("html, body").animate({
      scrollTop: topHeight
    }, 'slow');
  });

  if ($('.pagination').length) {
    InfititeScroll(window, document)
  }
});
initLiquidation = {
  scrollToList : function() {
    var topHeight = 0;
    $("html, body").animate({
      scrollTop: topHeight
    }, 'slow');
  }
}
