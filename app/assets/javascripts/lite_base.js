//= require _search_bar
if(!olook) var olook = {};
$(function(){
  olook.init();
});

olook = {
  init: function(){
      olook.menu();
      olook.cart();
      olook.myAccountMenu(); 
      olook.showSlideToTop();
      olook.slideToTop();  
      olook.boxLogin();
  },
    
  menu: function(){
    var $el, leftPos, newWidth, w = $("ul.default_new li .selected").outerWidth(), l = $("ul.default_new li .selected").position() && $("ul.default_new li .selected").position().left,
    top = ( $('div#wrapper_new_menu').offset() && $('div#wrapper_new_menu').offset().top ) - parseFloat(( $('div#wrapper_new_menu').css('margin-top') && $('div#wrapper_new_menu').css('margin-top') || '0' ).replace(/auto/, 0));
    
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
  
  newModal: function(content, a, l){

    var $modal = $("div#modal.promo-olook"), 
    h = a > 0 ? a : $("img",content).outerHeight(), 
    w = l > 0 ? l : $("img",content).outerWidth(), 
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
         'height'      : h+"px",
         'width'       : w+"px",
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
       'right' : _left - 25
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
      o.cartShow();
    }).on("mouseleave", function() {
      o.cartHide();
   });
  },

  cartShow: function() {
    $("#cart_summary").show();
    $('.coupon_warn').delay(6000).fadeOut();
    $("body").addClass('cart_submenu_opened');
  },

  cartHide: function(){
    $("#cart_summary").hide();
    $("body").removeClass('cart_submenu_opened');
  },
  
  myAccountMenu: function(){
    $('div.user ul li.submenu').on("mouseenter", function() {
      var link = $(this).find('a#account');
      var link_width = $(link).outerWidth();
      
      $(this).find('div.my_account').css('width', link_width - 2);
      $(link).addClass('hover');
    }).on("mouseleave", function() {
      var link = $(this).find('a#account');
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
