var filter = {};


filter.init = function(){
  /**
  * mode can be "wearing" or "product"
  */
  filter.visualization_mode = "product";
  filter.endlessScroll(window, document);
  filter.submitAndScrollUp();
  filter.seeAll();
  filter.selectedFilter();
  filter.showAllImages(filter.visualization_mode);
  filter.bindObjects();
  filter.changeVisualization();
}

filter.setMouseOverOnImages = function() {
  $('img.async').mouseover(function () {
    var backside_image = $(this).attr('data-backside');
    $(this).attr('src', backside_image);
  }).mouseout(function () {
    var showroom_image = $(this).attr('data-product');
    $(this).attr('src', showroom_image);
  });
}

filter.showAllImages = function(visualization_mode) {
  var field_name = 'data-' + visualization_mode;

  $('img.async').each(function(){
    var image = $(this).attr(field_name);
    $(this).attr('src', image);
  });

  if(visualization_mode == "product"){
    filter.setMouseOverOnImages();
  }
}


filter.endlessScroll = function(window, document){
   var url;
   if ($('.pagination').length) {
      $(window).scroll(function() {
         url = $('.pagination .next_page').attr('href');
         var canPaginate =  url && ($(window).scrollTop() > ($(document).height() - 1250)) && !$('.loading').is(':visible');
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
   $("form#filter").submit(function() {
      $('.loading').show();
      $('#sort_filter').val($("#filter").find("input:checked").val());
      $("#products").fadeOut("slow", function() {
         $(this).fadeIn("slow").html("");
       });    
   });

	$("html, body").delay(300).animate({scrollTop: 0}, 'slow');
} 
filter.seeAll = function(){
   $("#filter input[type='checkbox'].select_all").each(function(i){
      $(this).bind("click",function(){
         $(this).parents(".filter").find("input[type='checkbox']").not(".select_all").attr("checked", this.checked);
        
         $(this).parent().submit();
         filter.submitAndScrollUp();
      })
      
   });
}
filter.selectedFilter = function(){
   $("#filter input[type='checkbox']").not(".select_all").bind("click", function() {
      if(!$(this).is(":checked")) {
         $(this).parent().siblings("li").find("input[type='checkbox'].select_all").attr("checked", false);
      }
      filter.tags($(this).attr('id'), $(this).is(":checked"));
      
      $(this).parent().submit();
      filter.submitAndScrollUp();
      $('form#filter').find("input[type='checkbox']").attr("disabled", "true");
   });
}
filter.tags = function(name, flag){
   var classname = name.replace(' ','').toLowerCase(), list = $("#tags ul");
   
   if(flag == true) {
      list.hide().append('<li class="'+classname+'">'+name+'<button type="button" class="del-'+classname+'">( x )</button></li>').delay(100).fadeIn();
      window.setTimeout('filter.deleteTag("'+classname+'")', 300)   
   }   
   else {
      list.hide();
      list.find("li."+classname).fadeOut().delay(300).remove();
      list.fadeIn();
   }   
}
filter.deleteTag = function(classname){
   $("button.del-"+classname).bind("click", function(){
      classname = classname.toLowerCase(), filterId = $(".filter input#"+classname);
      $(filterId).attr("checked", false);
      flag = filterId.is(":checked");      
      filter.tags(classname,flag);
      filterId.parent().submit();
      filter.submitAndScrollUp();
   });
}
filter.cleanCategory = function(event){
   event.preventDefault();
   event.stopPropagation();
   $(event.target).parent().find("li").each(function(){
      $(this).find("input[type='checkbox']:checked").attr("checked", false);
      $("div#tags li."+$(this).find("input").attr('id')).remove();
   });
   $(event.target).parent().submit();
}
filter.toggleFilter = function(event){
   event.preventDefault();
   event.stopPropagation();
   style = $(event.target).attr('class');
   style = (style.indexOf("opened") >= 0) ? style.replace("opened", "") : style+" opened";
    
   $(event.target).attr('class', style);
   opened = (style.indexOf("opened") >= 0);

   if(opened){
      $(event.target).parent().find("ol").show();
      $(event.target).parent().find("button.clear_filter").show();
   } else {
      $(event.target).parent().find("ol").hide();
      $(event.target).parent().find("button.clear_filter").hide();
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
      filter.toggleFilter(event);
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

$(function(){
  filter.init();
  $('#order_filter').change(function() {
     $("form#filter").submit();
   });
})