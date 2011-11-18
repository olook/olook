$(document).ready(function() {
  var msie6 = $.browser == 'msie' && $.browser.version < 7;
  if (!msie6 && $('nav.menu').length == 1) {
    var top = $('nav.menu').offset().top - parseFloat($('nav.menu').css('margin-top').replace(/auto/, 0));
    $(window).scroll(function (event) {
      var y = $(this).scrollTop();
      if (y >= top) {
        $('nav.menu').addClass('fixed');
      } else {
        $('nav.menu').removeClass('fixed');
      }
    });
  } 
  

  if($('#error-messages').html().length >= '73'){
    $('.alert').parent().slideDown('1000', function() {
      $('.alert').parent().delay(2000).slideUp();
    })
  }

  $("#facebook_invite_friends").click(function(event) {
    event.preventDefault();
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

  var items_replace = new Array('.home > a, .send-button, .box h3, .full-banner .close, .full-banner li')

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

    $('.dialog img, .overlay, .dialog #close_dialog').click(function(){
      $('.dialog, .overlay').fadeOut('slow', function(){
        $('.dialog, .overlay').remove();
      });
    });
  }

  $('.full-banner').fadeIn('slow');
  $('.full-banner .close').click(function(event){
    $(this).parent().fadeOut(2000, function(){
      $(this).remove();
    });
    event.preventDefault();
  });

  $("#sign-up li.cpf input[type='text']").keydown(function(evt) {
    var theEvent = evt || window.event;
    var key = theEvent.keyCode || theEvent.which;
    key = String.fromCharCode(key);
    var regex = /[0-9]/ig;
    if(evt.keyCode != 8) {
      if( !regex.test(key) ) {
        theEvent.returnValue = false;
        if(theEvent.preventDefault) theEvent.preventDefault();
      }
    }
  });

});
