jQuery(function() {
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

  $('.clean_filters').hide();

  $('.clean_filters').click(function(e) {
    $(':checkbox').attr('checked', false);
    $(this).parent().submit();
    $('.clean_filters').hide();
  });

  $(':checkbox').click(function(e) {
    filter_checkboxes = $("#filters_container :checked").not("#33,#34,#35,#36,#37,#38,#39,#40");
    if (filter_checkboxes.size() > 0) {
      $('.clean_filters').show();
    } else {
      $('.clean_filters').hide();
    }
  });

 });

$(function(){
  $('#filter_option').change(function() {
    //TODO: the following lines are duplicated
    $('.filter_option')
    $('.loading').show();
    var selected_sort = $(this).val() ;
    $('#sort_filter').val(selected_sort);
    $("#products").fadeOut("slow", function() {
      $(this).fadeIn("slow").html("");
    });

    $('form#filter').submit();
  });

})


