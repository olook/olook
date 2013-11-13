$(document).ready(function() {
  function showFirstUl(el) {
    el = $(el);
    el.siblings('li').hide();
    var firstUl = el.children();
    firstUl.show();
    firstUl.children("li.question").show();
    $(".bt_back").show();
  }
  $('ul.click_show_child li.question, ul.click_show_child li.subtitle_site.active').click(function(e){
    e.stopPropagation();
    showFirstUl(this);
    $(this).addClass("como_funciona");
  });
  $('.bt_back').click(function(e){
    e.preventDefault();
    $('ul.click_show_child').children('li').show().find('ul.question_box, .answer').hide();
    $('ul.click_show_child').find('.como_funciona').removeClass("como_funciona");
    $('.bt_back').hide();
  });
  $('a.sac').click(function(ev){
    window.open('http://olook.neoassist.com/?action=neolive&th=sac&scr=request&ForcaAutenticar=1',
    'Continue_to_Application','width=500,height=500');
    ev.preventDefault();
    return false;
  });
  $('a.moda').click(function(ev){
    window.open('http://olook.neoassist.com/?action=neolive&th=moda&scr=request&ForcaAutenticar=1',
    'Continue_to_Application','width=500,height=500');
    ev.preventDefault();
    return false;
  });
  $(".moda_online").mouseover(function() {
    $(".hint").show();
  });
  $(".moda_online").mouseout(function() {
    $(".hint").hide();
  });
});
