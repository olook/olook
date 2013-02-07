var filter = {};

filter.init = function(){
   filter.endlessScroll(window, document);
   filter.submitAndScrollUp();
   filter.seeAll();
   filter.selectedFilter();
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

      filter.tags($(this).siblings().text(), $(this).is(":checked"));
      
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
      classname = classname.toLowerCase(), filterId = $(".filter input#"+classname), flag = filterId.is(":checked");

      $(filterId).attr("checked", false);
      filter.tags(classname,flag);
      filterId.parent().submit();
      filter.submitAndScrollUp();
   });
}
filter.cleanCategory = function(){
   $("button.clean_filter").each(function(){
      $(this).next().find("input[type='checkbox']:checked").attr("checked", false);
      
   })
}
filter.toggleFilter = function(){
   $(".filter_type").each(function(){
      
   })
}


$(function(){
  filter.init();
})