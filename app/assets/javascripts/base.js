$(document).ready(function() {

  if($('.alert').text() != ''){
    $('.alert').parent().slideDown('1000', function() {
      $('.alert').parent().delay(2000).slideUp();
    })
  }

  $("#facebook_invite_friends").click(function() {
    sendFacebookMessage();
  });

  $("#facebook_post_wall").click(function() {
    postToFacebookFeed();
  });

  $(document).bind('keydown', 'esc',function () {
    $('#sign-in-dropdown').hide();
    $('body').removeClass('dialog-opened');
    return false; 
  });

  var items_replace = new Array('.colors h3, .home a, nav a, .send-button, .banner a, #share-mail h1, #import-contacts h1, #invite-mail h1, .full-banner .close, .full-banner li')
  
  Cufon.replace(items_replace);
  
  if($('.dialog').length == 1) {
    width = $(document).width();
    height = $(document).width();
    viewWidth = $(window).width();
    viewHeight = $(window).height();
    imageW = $('.dialog img').width();
    imageH = $('.dialog img').height();

    $('body').prepend("<div class='overlay'></div>");
    $('.overlay').width(width).height(height);

    $(".dialog img").animate({
      width: 'toggle',
      height: 'toggle'
    });
    
    $('body .dialog').css("left", (viewWidth - '930') / 2);
    $('body .dialog').css("top", (viewHeight - '525') / 2);

    $('.dialog img').fadeIn('slow');

    $('.dialog img, .overlay').click(function(){
      $('.dialog, .overlay').fadeOut('slow', function(){
        $('.dialog, .overlay').remove();
      });
    });
  }

  $('.full-banner').fadeIn('slow');
  $('.full-banner .close').click(function(event){
    $(this).parent().fadeOut('slow', function(){
      $(this).remove();
    });
    event.preventDefault();
  });

});
