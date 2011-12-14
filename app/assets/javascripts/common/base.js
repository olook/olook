$(document).ready(function() {
  initBase.dialogLogin();
  initBase.loadJailImages();
  initBase.customSelect();

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

  if($(window).width() < "1200") {
    $("#wrapper_menu .menu").addClass("smaller");
  }

  $(window).resize(function() {
    width = $(this).width();
    menu = $("#wrapper_menu .menu");
    if(width < "1200") {
      $(menu).addClass("smaller");
    } else {
      $(menu).removeClass("smaller");
    }
  });

  if($('#error-messages').html().length >= '73'){
    $('.alert').parent().slideDown('1000', function() {
      $('.alert').parent().delay(5000).slideUp();
    })
  }

  $("ol.addresses li.address_item ul.links li a.select_address").live("click", function() {
    if($(this).parents("li.address_item").hasClass("add") == false) {
      lists = $(this).parents("ol").find("li");
      lists.find("input").attr('checked', false);
      lists.removeClass("selected");
      $(this).parents("li.address_item").find('input').attr('checked', true);
      $(this).parents("li.address_item").addClass('selected');
      return false;
    }
  });

  $("#facebook_invite_friends").click(function(event) {
    event.preventDefault();
    sendFacebookMessage();
  });

  $("#facebook_post_wall").click(function() {
    postToFacebookFeed();
  });

  $(document).bind('keydown', 'esc',function () {
    $('#sign-in-dropdown').hide();
    $("div#wrapper_menu nav.menu ul li.cart ul.submenu").hide();
    $('body').removeClass('dialog-opened');
    return false;
  });

  $("div#wrapper_menu nav.menu ul li.cart ul.submenu").live('click', function(e) {
    if($('body').hasClass('cart_submenu_opened')) {
      e.stopPropagation();
    }
  });

  $('body.cart_submenu_opened').live("click", function(e) {
    if($("div#wrapper_menu nav.menu ul li.cart ul.submenu").is(':visible')) {
      $("div#wrapper_menu nav.menu ul li.cart ul.submenu").hide();
      $(this).removeClass("cart_submenu_opened");
      e.stopPropagation();
    }
  });

  if($('.dialog.first_visit').length == 1) {
    initBase.openDialog();

    $(".dialog img").animate({
      width: 'toggle',
      height: 'toggle'
    });

    $('body .dialog').css("left", (viewWidth - '930') / 2);
    $('body .dialog').css("top", (viewHeight - '525') / 2);

    $('.dialog img').fadeIn('slow');
    initBase.closeDialog();
  }

  $("a.open_login").live("click", function() {
    initBase.openDialog();
    $('body .dialog').show();
    $('body .dialog').css("left", (viewWidth - '930') / 2);
    $('body .dialog').css("top", (viewHeight - '515') / 2);
    $('body .dialog #login_modal').fadeIn('slow');
    initBase.closeDialog();
  });


  $('.full-banner').fadeIn('slow');
  $('.full-banner .close').click(function(event){
    $(this).parent().fadeOut(2000, function(){
      $(this).remove();
    });
    event.preventDefault();
  });

  $("#sign-up li.cpf input[type='text']").setMask({
    mask: '99999999999'
  });

  $("div#wrapper_menu nav.menu ul li a.cart").live("click", function() {
    $(this).parent("li").find("ul").show();
    $("body").addClass('cart_submenu_opened');
  });

  $("div#wrapper_menu nav.menu ul li.cart ul.submenu li a.close").live("click", function() {
    $(this).parents("ul.submenu").hide();
  });

  $("div#wrapper_menu nav.menu ul li.cart ul.submenu li a.delete").live("click", function() {
    $(this).parent("li").remove();
  });

  $("input:text.zip_code").setMask({
    mask: '99999-999'
  });

  $("input:text.phone").setMask({
    mask: '(99)9999-9999'
  });

  $("input:text.expiration_date").setMask({
    mask: '19/99'
  });

  $("input:text.user_identification").setMask({
    mask: '999.999.999-99'
  });

  $("input:text.cpf").setMask({
    mask: '99999999999'
  });

  $("input:text.date").setMask({
    mask: '99/19/9999'
  });

  $("input:text.credit_card").setMask({
    mask: '9999999999999999'
  });

  $("input:text.security_code").setMask({
    mask: '9999'
  });

  $(".form_amount").change(function(){
    $(this).submit();
  });

  $("ul.submenu li form.delete")
    .bind("ajax:success", function(evt, xhr, settings){
     var defaultQuantity = 1;
     var items = parseInt($("#cart_items").text());
     $("#cart_items").text(items - defaultQuantity);
     $(this).parent("li.product").fadeOut("slow");
  })
});

initBase = {
  dialogLogin : function() {
    $('a.trigger').live('click', function(e){
      el = $(this).attr('href');

      $(this).parents('#session').find('.' + el).toggle('open');
      $(this).parents('body').addClass('dialog-opened');

      e.preventDefault();

      $('.sign-in-dropdown').live('click',function(e) {
        if($('body').hasClass('dialog-opened')) {
          e.stopPropagation();
        }
      });

      $('body.dialog-opened').live('click', function(e){
        if($('.sign-in-dropdown').is(':visible')){
          $('.sign-in-dropdown').toggle();
          $(this).removeClass('dialog-opened');
          e.stopPropagation();
        }
      });
    });
  },
  
  loadJailImages : function () {
    $("img.asynch-load-image").jail({selector: '#asynch-load', event: 'click'});
  },

  customSelect : function() {
    if (!$.browser.opera) {
      $('select.custom_select').each(function(){
        var title = $(this).attr('title');
        if( $('option:selected', this).val() != ''  ) title = $('option:selected',this).text();
        $(this).css({'z-index':10,'opacity':0,'-khtml-appearance':'none'}).after('<span class="select">' + title + '</span>').change(function(){
          val = $('option:selected',this).text();
          $(this).next().text(val);
        })
      });
    };
  },

  openDialog : function () {
    width = $(document).width();
    height = $(document).width();
    viewWidth = $(window).width();
    viewHeight = $(window).height();
    imageW = $('.dialog img').width();
    imageH = $('.dialog img').height();

    $('body').prepend("<div class='overlay'></div>");
    $('.overlay').width(width).height(height);
  },

  closeDialog : function() {
    $('.dialog img, .overlay, .dialog #close_dialog').click(function(){
      $('.dialog, .overlay').fadeOut('slow', function(){
        $('.dialog, .overlay').hide();
      });
    });
  }
}
