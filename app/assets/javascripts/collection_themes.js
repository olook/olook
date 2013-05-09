var filter = {}, h = 0;


filter.init = function(){
  /**
  * visualization_mode can be "wearing" or "product"
  */
  filter.visualization_mode = "product";
  filter.endlessScroll(window, document);
  filter.showAllImages(filter.visualization_mode);
  filter.changeVisualization();
  filter.submitAndScrollUp();
  filter.fillFilterTags();
  filter.bindObjects();
  filter.selectedFilter();
}

filter.spyOverChangeImage = function(){
   $(".spy").on({
      mouseover: function() {
         var backside_image = $(this).parents(".hover_suggestive").next().find("img").attr('data-backside');
         $(this).parents(".hover_suggestive").next().find("img").attr('src', backside_image);
       },
       mouseout: function() {
         var field_name = 'data-' + filter.visualization_mode;
         var showroom_image = $(this).parents(".hover_suggestive").next().find("img").attr(field_name);
         $(this).parents(".hover_suggestive").next().find("img").attr('src', showroom_image);
       }
   });
}
filter.setMouseOverOnImages = function() {
     $('img.async').mouseover(function () {
       var backside_image = $(this).attr('data-backside');
       if(/http.*/.test(backside_image))
         $(this).attr('src', backside_image);
     }).mouseout(function () {
       var field_name = 'data-' + filter.visualization_mode;
       var showroom_image = $(this).attr(field_name);
       if(/http.*/.test(showroom_image))
         $(this).attr('src', showroom_image);
     });
}
filter.showAllImages = function() {
  var field_name = 'data-' + filter.visualization_mode;

  $('img.async').each(function(){
    var image = $(this).attr(field_name);
    if(/http.*/.test(image))
      $(this).attr('src', image);
  });

  filter.setMouseOverOnImages();
  filter.spyOverChangeImage();
}
filter.endlessScroll = function(window, document){
   var url;
   if ($('.pagination').length) {
      $(window).scroll(function() {
         url = $('.pagination .next_page').attr('href');
         var canPaginate =  url && ($(window).scrollTop() > ($(document).height() - 1750 /* 1250 without the banner */)) && !$('.loading').is(':visible');
         if (canPaginate) {
            $('.loading').show();
            $('.pagination .next_page').remove();
            $('form#filter').find("input[type='checkbox']").attr("disabled", "true");
            return $.getScript(url);
         }
      });
   }
}
filter.submitAndScrollUp = function(){
  $("form#filter").bind('ajax:before', function() {
    if($('input[name="shoe_sizes[]"]:checked').length == 0) {
      if($(this).find('.hidden_shoe_sizes').length == 0)
        $(this).append('<input type="hidden" name="shoe_sizes[]" value="" class="hidden_shoe_sizes" />');
    } else {
      $(this).find('.hidden_shoe_sizes').remove();
    }
    var newURL = window.location.protocol + "//" + window.location.host + window.location.pathname + '?';
    newURL += $(this).serialize();
    if(window.history.pushState) {
      window.history.pushState('', '', newURL);
    } else {
      window.location = newURL;
      return false;
    }
    $('.loading').show();
    $('#category_filters').find('ol, .arrow, .clear_filter').hide();
    var selected_sort = $("select#filter_option").val() ;
    $('#sort_filter').val(selected_sort);
    $("#products").fadeOut("slow", function() {
      $(this).fadeIn("slow").html("");
    });
    $("html, body").delay(300).animate({scrollTop: $(".filters").length ? h : 0}, 'slow');
  }).bind('ajax:complete', function(){
    $('#category_filters .opened').removeClass('opened');
  });
}
filter.seeAll = function(){
   $("#filter input[type='checkbox'].select_all").each(function(i){
      $(this).bind("click",function(){
         $(this).parents(".filter").find("input[type='checkbox']").not(".select_all").attr("checked", this.checked);

         $(this).parent().submit();
      })
   });
}
filter.placeTag = function(el){
  if(!$(el).is(":checked")) {
    $(el).parent().siblings("li").find("input[type='checkbox'].select_all").attr("checked", false);
    if($(el).parent().parent().find("li input[type='checkbox']:checked").length == 0){
      $(el).parent().parent().parent().find("button.clear_filter").hide();
    }
  } else if($(el).parent().parent().find("li input[type='checkbox']:checked").length > 0){
    $(el).parent().parent().parent().find("button.clear_filter").show();
  }
  filter.tags($(el).attr('id'),$(el).next().text() ,$(el).is(":checked"));
}
filter.selectedFilter = function(){
   $("#filter input[type='checkbox']").not(".select_all").bind("click", function() {
     filter.placeTag(this);

     $(this).parent().submit();
     $('form#filter').find("input[type='checkbox']").attr("disabled", "true");
   });
}
filter.tags = function(name, desc, flag){
   var classname = name.replace(' ','').toLowerCase(), list = $("#tags ul");

   if(flag == true) {
      $("section.filters").fadeIn();
      list.hide().prepend('<li class="'+classname+'">'+desc+'<button type="button" class=" delete del-'+classname+'">( x )</button></li>').delay(100).fadeIn();
      window.setTimeout('filter.deleteTag("'+classname+'")', 300);
      filter.cleanFilter();
   }
   else {
      list.hide();
      list.find("li."+classname).fadeOut().delay(300).remove();
      list.fadeIn();
   }

   if($("#tags ul").children().size() < 2){
      $("section.filters").delay(300).fadeOut();
   }
}
filter.fillFilterTags = function() {
  $("#filter input[type'checkbox']:checked").each(function(idx, el){
    filter.placeTag(el);
  });
}
filter.deleteTag = function(classname){
   $("button.del-"+classname).bind("click", function(){
      classname = classname.toLowerCase(), filterId = $(".filter input#"+classname);
      $(filterId).attr("checked", false);
      flag = filterId.is(":checked");
      filter.tags(classname,null,flag);
      filterId.parent().submit();
   }).hover(
      function(){
         $(this).next().fadeIn();
      },
      function(){
         $(this).next().fadeOut();
      }
   )
}
filter.cleanCategory = function(event){
   event.preventDefault();
   event.stopPropagation();
   canSubmit = false;

   $(event.target).parent().find("li").each(function(){
      checked = $(this).find("input[type='checkbox']:checked");
      if(checked.attr("checked")){
        canSubmit = true;
        checked.attr("checked", false);
        $("div#tags li."+$(this).find("input").attr('id')).remove();
      }
   });

   if(canSubmit){
     $(event.target).parent().submit();
     $(event.target).hide();
   }

   if($("#tags ul li").length < 1){
      $("section.filters").fadeOut();
   }

}

filter.bindObjects = function(){
   $('.clear_filter').bind('click', function(event){
      event.preventDefault();
      event.stopPropagation();
      filter.cleanCategory(event);
   });

   $(".filter_type").bind('click', function(event){
     event.preventDefault();
     event.stopPropagation();
     var filters = $(this).parent().parent();
     var clicked_filter = $(this).parent();

     filters.find(".clear_filter").hide();
     if(clicked_filter.find('.filter_type').hasClass('clicked')){
       clicked_filter.find("ol, .arrow, .clear_filter").hide();
       filters.find('.filter_type').removeClass('clicked');
     } else {
       clicked_filter.find("ol, .arrow").show();
       if(clicked_filter.find('input:checked').length > 0) {
         var filter_box_height = clicked_filter.find('ol').height();
         clicked_filter.find(".clear_filter").show();
       }
       filters.find('.filter_type').removeClass('clicked');
       clicked_filter.find('.filter_type').addClass('clicked');
     }
   });

}
filter.changeVisualization = function(){
   $(".exhibition-mode p span").bind('click', function(){
      if($(this).hasClass("product")){
         filter.visualization_mode = "product";
         filter.showAllImages(filter.visualization_mode);
         $(this).addClass("selected").next().next().removeClass("selected");
      }
      else{
         filter.visualization_mode = "wearing";
         filter.showAllImages(filter.visualization_mode);
         $(this).addClass("selected").prev().prev().removeClass("selected");
      }
   })
}
filter.cleanFilter = function(){
   $(".cleanFilter").bind('click', function(){
      $("#tags ul").empty();
      $(".filters").fadeOut();
      $(".filter input:checked").attr("checked", false).delay(150).parent().submit();
      $('.clear_filter').fadeOut();
      $("html, body").delay(300).animate({scrollTop: 0}, 'slow');
   })
}

$(function(){
  if($(".exhibition-mode").position()){
    h = $(".exhibition-mode").position().top;
    h += 105;
  }

  filter.init();

  if($("div#products_amamos").size() > 0) {
    $("div#products_amamos ul").carouFredSel({
      auto: false,
      width: 780,
      items: 3,
      prev : {
        button : ".prev_collection",
        items : 1
      },
      next : {
        button : ".next_collection",
        items : 1
      },
      pagination: {
        container : "div#products_amamos .pagination",
        items : 1
      }
    });
  };

  $('#sort_filter, #category_filters').change(function() {
    //TODO: the following lines are duplicated
    $('.loading').show();
    $("#products").fadeOut("slow", function() {
      $(this).fadeIn("slow").html("");
    });
    $(".filters").show();
    $('form#filter').submit();
  });

  $('#category_id').change(function() {
    $("#tags .cleanFilter").trigger("click");
    $("#category_filters").fadeOut("slow").html('');
    //TODO: the following lines are duplicated
    $('.loading').show();
    $("#products").fadeOut("slow", function() {
      $(this).fadeIn("slow").html("");
    });
    $('form#filter').submit();
  });

});
