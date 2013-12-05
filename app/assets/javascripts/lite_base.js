//= require plugins/new_modal
if(!olook) var olook = {};

$(function(){
  olook.init();
});

o = olook;

olook.init = function(){
  olook.menu();
  olook.cart();
  olook.myAccountMenu();
  olook.showSlideToTop();
  olook.slideToTop();
  olook.boxLogin();
  olook.showEmailBar();
  olook.goto_form_reseller();
  olook.megamenu();
  olook.mercadoPagoBanner();
}

olook.megamenu = function() {
  if($('body.mobile').length > 0) return;
  $('.default_new li').on(
    {
      mouseover: function() {
        $(this).find('div').show();
        $(this).find('a:first').addClass('selecionado');
      },

      mouseleave: function() {
        $(this).find('div').hide();
        $(this).find('a:first').removeClass('selecionado');
      }
    }
  );
}

olook.mercadoPagoBanner = function() {
  $("a.mercado_pago_button").click(function(e){
    var content = $("div.mercado_pago");
    var img = content.data('url');
    content.html("<img src='" + img + "' />");
    content.css({'width': '800px', 'height': '640px', 'position': 'fixed !important'});
    modal.show(content,640,800);
    e.preventDefault();
  });
}

olook.menu = function(){
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
}

olook.boxLogin = function() {
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
}

olook.cart = function(){
  $(".new_sacola a.cart,#cart_summary").on("mouseenter", function() {
    o.cartShow();
  }).on("mouseleave", function() {
    o.cartHide();
 });
}

olook.cartShow = function() {
  $("#cart_summary").show();
  $('.coupon_warn').delay(6000).fadeOut();
  $("body").addClass('cart_submenu_opened');
  $(".new_sacola a").addClass('selecionado');
}

olook.cartHide = function(){
  $("#cart_summary").hide();
  $("body").removeClass('cart_submenu_opened');
  $(".new_sacola a").removeClass('selecionado');
}

olook.myAccountMenu = function(){
  $('div.user ul li.submenu').on("mouseenter", function() {
    var link = $(this).find('a#account');
    var link_width = $(link).outerWidth();

    $(this).find('div.my_account').css('width', link_width - 2);
    $(link).addClass('hover');
  }).on("mouseleave", function() {
    var link = $(this).find('a#account');
    $(link).removeClass('hover');
  });
}

olook.showSlideToTop  = function() {
  $(window).scroll(function() {
    if($(window).scrollTop() > 440) {
      $('a#go_top').fadeIn();
    } else {
      $('a#go_top').fadeOut();
    }
  });
}

olook.goto_form_reseller = function() {
  $('a#form_reseller').live('click', function(e) {
    $("html, body").animate({
      scrollTop: 1250
    }, 'fast');
    e.preventDefault();
  });
}


olook.slideToTop = function() {
  $('a#go_top').on('click', function(e) {
    $("html, body").animate({
      scrollTop: 0
    }, 'fast');
    e.preventDefault();
  });
}

olook.showFlash = function() {
  if( error = $('#error-messages').html() ){
    if( error.length >= '82' ){
      $('.alert').parent().slideDown('1000', function() {
        $('.alert').parent().delay(5000).slideUp();
      })
    }
  }
}

olook.validateEmail = function(email) {
    var regex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return regex.test(email);
}

olook.registerEmail = function(){
  $("#modal_footer button.close").on("click", function(){
    if($.cookie("email_bar") != "2"){
      $.cookie("email_bar", "1", { expires: 1, path: '/' });
      $("#modal_footer").fadeOut();
    }
  })

  $("p.nao-exibir input").click(function(){
    $.cookie("email_bar", "2", { expires: 100, path: '/' });
    $("#modal_footer").fadeOut();
  });

  var email_field = $("#modal_footer input.email"), elem = $("#modal_footer .presentation");

  $("button.register").on("click", function(){
    elem.animate({"left": -elem.width()},"slow");
    $("#modal_footer img").animate({"right": '865px'},"slow");
    $("#modal_footer .form").animate({"right": '0'},"slow");

    $(this).fadeOut().next().delay(200).fadeIn().next().fadeIn();

    email_field.on({
      focus: function(){
        $(this).addClass("txt-black");
        if(email_field.val() == "seunomeaqui@email.com.br"){
          $(this).val("");
        }
      },
      focusout: function(){
        if( $.trim($(this).val()) == "" ){
          $(this).removeClass("txt-black").val("seunomeaqui@email.com.br");
        }
      }
    });

  });

  $("#modal_footer button.close").on("click", function(){
    $("#modal_footer").fadeOut();
    $.cookie("email_bar", "1", { expires: 1, path: '/' });
  });

  $('form#subscribe_form').submit(function(event){
    email = email_field.val();
    event.preventDefault();
    $("#modal_footer button.close").off("click");

    if(o.validateEmail(email) && email != "seunomeaqui@email.com.br"){
      $(this).on('ajax:success', function(evt, data, status, xhr){
        $("#modal_footer .form, .register2, .termos").fadeOut();
        $.cookie("email_bar", "2", { expires: 200, path: '/' });
        if(data.status == "ok"){
          $("#modal_footer #ok-msg1").delay(300).fadeIn();

        }else if(data.status == "error"){
          $("#modal_footer #ok-msg2").delay(300).fadeIn();
        }

        email_field.off("focusout").removeClass("txt-black error").val("seunomeaqui@email.com.br");

        if(email_field.prev().hasClass("error")){$("p.error").removeClass("error")}
        $("#modal_footer").delay(5500).fadeOut();

      });
    }else{
      email_field.addClass("error");
      $("#modal_footer .form p span.txt").hide().next().fadeIn().parent().addClass("error");
    }
  });
}



olook.showEmailBar = function(){
 if($.cookie("newsletterUser") == null && $.cookie("ms") == null && $.cookie("ms1") == "1" && $.cookie("email_bar") == null && !/(?:pagamento\/login|admins|quiz|cadastro)/.test(window.location.href)){
    $("#modal_footer").fadeIn();
		o.registerEmail();
	}
}