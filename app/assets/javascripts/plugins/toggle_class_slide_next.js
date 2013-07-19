if(!olook) var olook = {};
olook.toggleClassSlideNext = function(selector){
  $(selector).click(function(){
    $(this).toggleClass("close").next().slideToggle();
  });
}
