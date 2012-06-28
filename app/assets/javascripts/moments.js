jQuery(function() {
  var submit_moments_form;
  var url;

  $('#moment_filter').submit(function() {
    $('.loading').show();
    $('#sort_filter').val($("#order_filter").find("option:selected").val());
    $("#products").fadeOut("slow", function() {
      $(this).fadeIn("slow");
      $(this).html("");
    });
    initMoment.scrollToList();
  });

  if($("form#moment_filter input").is(":checked")) {
    $("form#moment_filter").submit();
  }

  $('#moment_order_filter').change(function() {
    $("form#moment_filter").submit();
  });

  $("#moment_filter").find("input[type='checkbox'].select_all").each(function(i){
    if(this.checked){
      $(this).parents(".filter").find("input[type='checkbox']").not(".select_all").attr("checked", this.checked);
    }
  });

  $("#moment_filter").find("input[type='checkbox'].select_all").live("click", function() {
    checkbox = this
    $('div.content nav li a').each(function(i,nav){
      href = $(nav).attr('href');
      if(checkbox.checked){
        href += (!href.match(/\?/)) ? '?' : '&';
        if(!href.match(/checkbox.name/ig)){
          href += checkbox.name + '=1';
        }
      } else {
        href = href.replace(checkbox.name+'=1', '').replace(/&+/g,'&');
      }
      $(nav).attr('href', href.replace(/(?:&|\?)$/,''));
    });
    $(this).parents(".filter").find("input[type='checkbox']").not(".select_all").attr("checked", this.checked);
    clearTimeout(submit_moments_form);
    $("form#moment_filter").submit();
  });

  $('#moment_filter').find("input[type='checkbox']").not(".select_all").click(function() {
    if(!$(this).is(":checked")) {
      $(this).parent().siblings("li").find("input[type='checkbox'].select_all").attr("checked", false);
    }
    // $(".loading").show();
    $(this).parent().submit();
    $('#moment_filter').find("input[type='checkbox']").attr("disabled", "true");
  });

  if ($('.pagination').length) {
    $(window).scroll(function() {
      url = $('.pagination .next_page').attr('href');
      var canPaginate =  url && ($(window).scrollTop() > ($(document).height() - $(window).height() - 800)) && !$('.loading').is(':visible');
      if (canPaginate) {
        $('.loading').show();
        $('.pagination .next_page').remove();
        $('#moment_filter').find("input[type='checkbox']").attr("disabled", "true");
        return $.getScript(url);
      }
    });
  }
});

initMoment = {
  scrollToList : function() {
    var topHeight = 400;
    $("html, body").animate({
      scrollTop: topHeight
    }, 'slow');
  }
}

