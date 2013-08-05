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
       $(this).attr('src', backside_image);
     }).mouseout(function () {
       var field_name = 'data-' + filter.visualization_mode;
       var showroom_image = $(this).attr(field_name);
       $(this).attr('src', showroom_image);
     });
}
filter.showAllImages = function() {
  var field_name = 'data-' + filter.visualization_mode;

  $('img.async').each(function(){
    var image = $(this).attr(field_name);
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
    var newURL = window.location.protocol + "//" + window.location.host + window.location.pathname + '?', url = window.location.href;
    newURL += $(this).serialize();
    
    if(window.history.pushState) {
      window.history.pushState('', '', newURL);
    } else {
      window.location = newURL;
      return false;
    }
    $('.loading').show();
    $('#category_filters').find('ol, .tab_bg, .clear_filter').hide();
    $("#products").fadeOut("slow", function() {
      $(this).fadeIn("slow").html("");
    });
    //$("html, body").delay(300).animate({scrollTop: $(".filters").length ? h : 0}, 'slow');
  }).bind('ajax:complete', function(){
    $('#category_filters .opened').removeClass('opened');
  });
}

filter.sliderRange = function(start_position, final_position){

  $("#slider-range").slider({
      range: true,
      min: 0,
      max: 600,
      values: [ isNaN(start_position) ? 0 : start_position, isNaN(final_position) ? 600 : final_position ],
      slide: function( event, ui ) {
        $("#min-value").val("R$ " + ui.values[ 0 ]);
        $("#max-value").val("R$ " + ui.values[ 1 ]);
        $("#min-value-label").text("R$ " + ui.values[ 0 ]);
        $("#max-value-label").text("R$ " + ui.values[ 1 ]);
      },

      stop: function(event,ui){
        $("input#price").val(ui.values[ 0 ]+'-'+ui.values[ 1 ]);
        filter.submitAndScrollUp();
        $(this).parent().submit();
      }
  });

  $("#min-value").val("R$ " + $("#slider-range").slider("values", 0));
  $("#max-value").val("R$ " + $("#slider-range").slider("values", 1));
  $("#min-value-label").text($("#min-value").val());
  $("#max-value-label").text($("#max-value").val());
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
      $(el).siblings().find("button.clear_filter").hide();
    }
  } else if($(el).parent().parent().find("li input[type='checkbox']:checked").length > 0){
    $(el).siblings().find("button.clear_filter").show();
  }
  filter.tags($(el).attr('id'),$(el).next().text() ,$(el).is(":checked"));
}
filter.selectedFilter = function(){
   if($("#filter input[type='checkbox']").is(":checked")){
     $("#filter input[type='checkbox']:checked").parent().parent().parent().find("span.selected-type").addClass("filter_selected");
   }

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

   $(event.target).parent().parent().find("li").each(function(){
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

     filters.parent().parent().find("ol:visible,.tab_bg:visible").hide();
     if(clicked_filter.find('.filter_type').hasClass('clicked')){
       clicked_filter.find("ol, .tab_bg, .clear_filter").hide();
       filters.find('.filter_type').removeClass('clicked');
     } else {
       clicked_filter.find("ol, .tab_bg").show();
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
  $("input#price").val(start_position+'-'+final_position);
  
  filter.sliderRange(start_position, final_position);

  if($(".exhibition-mode").position()){
    h = $(".exhibition-mode").position().top;
    h += 105;
  }

  $("body").on("click", function(){
    if($("#category_filters div.filter ol").is(":visible")){
      $("#category_filters div.filter ol:visible, #category_filters div.filter .tab_bg:visible").hide();
      $("#category_filters div.filter span.select.clicked").removeClass("clicked");
    }
  });


  filter.init();

  if($("div#products_amamos").size() > 0) {
    $("div#products_amamos ul").carouFredSel({
      auto: false,
      width: 780,
      height: 375,
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
