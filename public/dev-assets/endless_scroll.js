function InfititeScroll(window, document){
  var url;
  $(window).scroll(function() {
    url = $('.pagination .next_page').attr('href');
    var canPaginate =  url && ($(window).scrollTop() > ($(document).height() - $(window).height() - 1750)) && !$('.loading').is(':visible');
    if (canPaginate) {
      $('.loading').show();
      $('.pagination .next_page').remove();
      $('form#filter').find("input[type='checkbox']").attr("disabled", "true");
      return $.getScript(url);
    }
  });
}

jQuery(function() {
  var submit_moments_form;
  var url;

  $('form#filter').on('ajax:before', function(xhr, settings) {
    $('.loading').show();
    $('#products').hide();
    $('#sort_filter').val($("#order_filter").find("option:selected").val());
    initMoment.scrollToList();
  });

  if($("form#filter input").is(":checked")) {
    $("form#filter").submit();
  }

  $("html").live("click", function() {
    $("div#shoe_size_filter div.sizes").hide();
  });

  $("div#shoe_size_filter span").live("click", function(e) {
    $(this).siblings(".sizes").toggle();
    e.stopPropagation();
  });

  $("div#shoe_size_filter div.sizes input").click(function(e) {
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
        $("div#shoe_size_filter span").text($(this).val());
      } else {
        if(index == 0) {
          textSize = $(this).val();
        } else {
          textSize = textSize + ", " + $(this).val();
        }

        $("div#shoe_size_filter span").text(textSize);
      }
    });
  });
  $('#order_filter').change(function() {
    $("form#filter").submit();
  });

  $("#filter").find("input[type='checkbox'].select_all").each(function(i){
    if(this.checked){
      $(this).parents(".filter").find("input[type='checkbox']").not(".select_all").attr("checked", this.checked);
    }
  });

  $("#filter").find("input[type='checkbox'].select_all").bind("click", function() {
    checkbox = this;
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
    $("form#filter").submit();
  });

  $('#filter').find("input[type='checkbox']").not(".select_all").bind("click", function() {
    if(!$(this).is(":checked")) {
      $(this).parent().siblings("li").find("input[type='checkbox'].select_all").attr("checked", false);
    }
    $(this).parent().submit();
    $('form#filter').find("input[type='checkbox']").attr("disabled", "true");

  });

  if ($('.pagination').length) {
    InfititeScroll(window, document);
  }
});

initMoment = {
  scrollToList : function() {
    var topHeight = $("#content").offset().top - 150;
    $("html, body").animate({
      scrollTop: topHeight
    }, 'slow');
  }
}
;
