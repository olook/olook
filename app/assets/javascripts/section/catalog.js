$(function() {
  $(".more_info_show").click(function(e){
    e.preventDefault();
      $(".summary,.more_info_show").css("display", "none");
      $(".full,.more_info_hide").css("display", "block");
  });
  $(".more_info_hide").click(function(e){
    e.preventDefault();
      $(".full,.more_info_hide").css("display", "none");
      $(".summary,.more_info_show").css("display", "block");
  });
});