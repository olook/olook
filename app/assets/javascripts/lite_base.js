olook = o = {} || null;

$(function(){
  o.init();
})

olook = o = {
  init: function(){
      o.menu();
      o.cart();
      o.myAccountMenu(); 
      o.showSlideToTop();
      o.slideToTop();  
      o.showBalloon();
  },
  
  showBalloon: function(){
    var t=$(".menu_new .stylist").position().top, l=$(".menu_new .stylist").position().left;
    $("img.balloon").css({"top": t -11, "left": l +20});
  
    $(".menu_new .stylist").on("mouseenter", function(){
      $("img.balloon").show();
    }).on("mouseleave", function(){
      $("img.balloon").hide();
    })
  },
  
  menu: function(){
    var $el, leftPos, newWidth, $magicLine = $("ul.default_new li#bar"), w = $("ul.default_new li .selected").outerWidth(), l = $("ul.default_new li .selected").position() && $("ul.default_new li .selected").position().left,
    top = ( $('div#wrapper_new_menu').offset() && $('div#wrapper_new_menu').offset().top ) - parseFloat(( $('div#wrapper_new_menu').css('margin-top') && $('div#wrapper_new_menu').css('margin-top') || '0' ).replace(/auto/, 0));
    
    $magicLine
    .width(w - 40)
    .css("left", l + 19)
    .data("origLeft", l + 19)
    .data("origWidth", w - 40);

    if($("ul.default_new li a").hasClass("selected")){
      $magicLine.fadeIn();
    }
    $("ul.default_new li").find("a").hover(function() {
        $el = $(this);
        leftPos = $el.position().left + 19;
        newWidth = $el.parent().width() - 40;

        if(!$magicLine.is(":visible")){
          $magicLine.fadeIn();
        }
        $magicLine.stop().animate({
            left: leftPos,
            width: newWidth
        });
    }, function() {
        $magicLine.stop().animate({
            left: $magicLine.data("origLeft"),
            width: $magicLine.data("origWidth")
        });
    });
    
    $(window).scroll(function (event) {
      var y = $(this).scrollTop();
      if (y >= top) {
        $('div#wrapper_new_menu').addClass('fixed');
      } else {
        $('div#wrapper_new_menu').removeClass('fixed');
      }
      event.preventDefault();
      event.stopPropagation();
    });
  },
  
  boxLogin: function() {
    $('p.new_login a.trigger').click(function(e){
      $("div.sign-in-dropdown").fadeIn();
      $("div.sign-in-dropdown form input#user_email").focus();
    
      $('body').on('click', function(e){
        if($('.sign-in-dropdown').is(':visible')){
          $('.sign-in-dropdown').fadeOut();
        }
        e.stopPropagation();
      });
      
      $('.sign-in-dropdown').on('click', function(e){
        e.stopPropagation();
      })

      e.stopPropagation();
      e.preventDefault();  
    });
  },
  
  newModal: function(content){
    var $modal = $("div#modal.promo-olook"), 
    h = $("img", content).length > 0 ? $("img",content).outerHeight() : $(content).outerHeight(), 
    w = $("img", content).length > 0 ? $("img",content).outerWidth() : $(content).outerWidth(), 
    ml = -parseInt((w/2)), mt = -parseInt((h/2)), 
    heightDoc = $(document).height(), 
    _top = Math.max(0, (($(window).height() - h) / 2) + $(window).scrollTop()), 
    _left=Math.max(0, (($(window).width() - w) / 2) + $(window).scrollLeft());
    
    $("#overlay-campaign").css({"background-color": "#000", 'height' : heightDoc}).fadeIn().bind("click", function(){
      _iframe = $modal.contents().find("iframe");
      if (_iframe.length > 0){
        $(_iframe).remove();
      }
      
      $("button.close").remove();
      $modal.fadeOut();
      $(this).fadeOut();
    });
    
    $modal.html(content)
      .css({
         'height'      : h,
         'width'       : w,
         'top'         : '50%',
         'left'        : '50%',
         'margin-left' : ml,
         'margin-top'  : mt
      })
     .delay(500).fadeIn().children().fadeIn();
    
     if($("button.close").length > 0){
       $("button.close").remove();
     }
     
     $('<button type="button" class="close" role="button">close</button>').css({
       'top'   : _top - 15,
       'right' : _left - 40
     }).insertAfter($modal);
     
    $("button.close, #modal a.me").click(function(){
       _iframe = $modal.contents().find("iframe");
       if (_iframe.length > 0){
         $(_iframe).remove();
       }
       
       $("button.close").remove();
       $modal.fadeOut();
       $("#overlay-campaign").fadeOut();
    })

  },
  
  cart: function(){
    $("p.new_sacola a.cart,#cart_summary").on("mouseenter", function() {
      $("#cart_summary").show();
      $("body").addClass('cart_submenu_opened');
    }).on("mouseleave", function() {
      $("#cart_summary").hide();
      $("body").removeClass('cart_submenu_opened');
    });
  },
  
  myAccountMenu: function(){
    $('div.user ul li.submenu').on("mouseenter", function() {
      var link = $(this).find('a#info_user');
      var link_width = $(link).outerWidth();
      
      $(this).find('div.my_account').css('width', link_width - 2);
      $(link).addClass('hover');
    }).on("mouseleave", function() {
      var link = $(this).find('a#info_user');
      $(link).removeClass('hover');
    });
  },
  
  showSlideToTop : function() {
    $(window).scroll(function() {
      if($(window).scrollTop() > 440) {
        $('a#go_top').fadeIn();
      } else {
        $('a#go_top').fadeOut();
      }
    });
  },

  slideToTop :function() {
    $('a#go_top').on('click', function(e) {
      $("html, body").animate({
        scrollTop: 0
      }, 'fast');
      e.preventDefault();
    });
  },

  showFlash: function() {
    if( error = $('#error-messages').html() ){
      if( error.length >= '82' ){
        $('.alert').parent().slideDown('1000', function() {
          $('.alert').parent().delay(5000).slideUp();
        })
      }
    }
  }
  
}
