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

  if( error = $('#error-messages').html() ){
    if( error.length >= '73' ){
      $('.alert').parent().slideDown('1000', function() {
        $('.alert').parent().delay(5000).slideUp();
      })
    }
  }


  $("header .info ul").fadeTransition();

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

  $('nav.menu ul.product_anchors li a').click(function() {
    cl = $(this).parent("li").attr("class");
    container = $("#"+cl+"_container");
    if(container.length > 0) {
      container_position = $("#"+cl+"_container").position().top;
      position = container_position - 40;
      $('html, body').animate({
        scrollTop: position
      }, 'slow');
    }
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
  $("input#address_zip_code").focusout(function(){
    if ($("input#address_zip_code").val().length < 9) {
      return true;
    }
    $.ajax({
      url: '/get_address_by_zipcode',
      dataType: 'json',
      data: 'zipcode=' + $("input#address_zip_code").val(),
      beforeSend: function(){
        $("input#address_zip_code").parents('.zip_code').prepend('<div class="preloader" style="float:right;width:30px;"></div>');
        $('form div.address_fields input').attr('disabled','disabled');
        $('form div.address_fields select').attr('disabled','disabled');
      },
      complete: function(){
        $('form div.address_fields input').removeAttr('disabled');
        $('form div.address_fields select').removeAttr('disabled');
        $(".main div.preloader").remove();
      },
      success: function(rs){
        if(rs['result_type'] >= 1){
          $('form input#address_city').val(rs['city']);
          $('form select#address_state').val(rs['state']);
          $('span.select').text(rs['state']);
        }
        if(rs['result_type'] == 1){
          $('form #address_street').val(rs['street']);
          $('form #address_neighborhood').val(rs['neighborhood']);
          $('form #address_number').removeAttr('disabled').focus();
        }else{
          $('form #address_street').removeAttr('disabled').focus();
        }
      }
    });
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

  $("ul.submenu li form.delete").bind("ajax:success", function(evt, xhr, settings){
    var defaultQuantity = 1;
    var items = parseInt($("#cart_items").text());
    var newItems = items - defaultQuantity;
    $("#cart_items").text(newItems);
    $(this).parent("li.product_item").fadeOut("slow", function() {
      $(this).remove();
    });
    if(newItems == 0) {
      $("nav.menu ul li.cart a.cart.selected").removeClass("selected");
    }
  });

  $("div.box_product div.line ol li a.product_color").live("mouseenter", function() {
    $(this).parents("ol").find("li a").removeClass("selected");
    $(this).addClass("selected");
    productBox = $(this).parents(".box_product");
    quantityBox = $(productBox).find("a.product_link").find("p.quantity");
    newLink = $(this).attr("href");
    newImg = $(this).attr("data-href");
    soldOut = $(this).parent().find("input[type='hidden'].sold_out").val();
    quantity = $(this).parent().find("input[type='hidden'].quantity").val();
    $(productBox).removeClass("sold_out");
    $(productBox).removeClass("stock_down");
    initBase.updateProductImage(productBox, newLink, newImg);
    initBase.updateProductFacebookLike(productBox, newLink);
    if(!initBase.isProductSoldOut(productBox, soldOut)) {
      initBase.checkProductQuantity(productBox, quantityBox, quantity);
    }
  });

  $("li.promotion div.box_product div.line ol li a.product_color").live("mouseenter", function() {
    productBox = $(this).parents(".box_product");
    percentageBox = $(productBox).find("a.product_link").find("p.percentage");
    percentage = $(this).parent().find("input[type='hidden'].percentage").val();
    $(percentageBox).find("span").text(percentage);
  });

  $("div#mask_carousel_showroom ul li a.video_link, div#carousel_lookbooks_product a.video_link").live("click", function(e) {
    var url = $(this).attr("rel");
    var title = $("<div>").append($(this).siblings(".video_description").clone()).remove().html();
    var youtube_id = initBase.youtubeParser(url);
    content = initBase.youtubePlayer(youtube_id);
    content += title;
    initBase.modal(content);
    e.preventDefault();
  });

  $(".ui-dialog-titlebar-close, .ui-widget-overlay").live("click", function() {
    $("div#modal").html("");
    $("div#modal").dialog("close");
  });
});

initBase = {
  youtubeParser : function(url) {
    var regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/;
    var match = url.match(regExp);
    if(match&&match[7].length==11) {
        return match[7];
    } else {
      return false;
    }
  },

  youtubePlayer : function(yt_id) {
    return "<iframe width='791' height='445' src='http://www.youtube.com/embed/"+ yt_id +"?rel=0&autoplay=1' frameborder='0' allowfullscreen></iframe>";
  },

  modal : function(content) {
    if($("div#modal").size() == 0) {
      $("body").prepend("<div id='modal'></div>");
    } else {
      $("div#modal").html("");
    }

    $("div#modal").prepend(content);

    $("div#modal").dialog({
      width: 'auto',
      modal: true
    });
  },

  updateProductImage : function(box, link, img) {
    $(box).find("a.product_link img").attr("src", img);
    $(box).find("a.product_link").attr("href", link);
  },

  updateProductFacebookLike : function(box, link) {
    $(box).find(".like_mask div.fb-like").attr("data-href", function(i,val){
      return val.replace(/\/produto\/\d+/, link);
    });
    $(box).find("iframe").attr("src", function(i, val){
      return val.replace(/%2Fproduto%2F\d+/, link.replace(/\//g, "%2F"));
    });
  },

  isProductSoldOut : function(box, soldOut) {
    if(soldOut == "sold_out") {
      $(box).addClass("sold_out");
      return true;
    }
  },

  checkProductQuantity : function(productBox, quantityBox, quantity) {
    if(quantity > 0 && quantity <= 3) {
      $(quantityBox).find("span").text(quantity);
      $(productBox).addClass("stock_down");
    }
  },

  dialogLogin : function() {
    $('a.trigger').live('click', function(e){
      el = $(this).attr('rel');

      $(this).parents('#session').find('.' + el).toggle('open');
      $(this).parents('body').addClass('dialog-opened');

      $("div.sign-in-dropdown form input#user_email").focus();

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
        if($('option:selected', this).val() != '') {
          title = $('option:selected',this).text();
        }
        $(this).css({'z-index':10,'opacity':0,'-khtml-appearance':'none'}).after('<span class="select">' + title + '</span>').change(function(){
          val = $('option:selected',this).text();
          $(this).next().remove();
          $(this).after("<span class='select'>"+val+"</span>");
        });
      });
    };
  },

  openDialog : function () {
    width = $(document).width();
    height = $(document).height();
    viewWidth = $(window).width();
    viewHeight = $(window).height();

    $('body').prepend("<div class='overlay'></div>");
    $('.overlay').width(width).height(height);

    $(".dialog").animate({
      width: 'toggle',
      height: 'toggle'
    }, 'normal', function() {
      imageW = $('.dialog img').width();
      imageH = $('.dialog img').height();
      $('body .dialog.liquidation').css("left", (viewWidth - imageW) / 2);
      $('body .dialog.liquidation').css("top", (viewHeight - imageH) / 2);

      $('.dialog img').fadeIn('slow');
    });
  },

  closeDialog : function() {
    $('.dialog img, .overlay, .dialog #close_dialog').click(function(){
      $('.dialog, .overlay').fadeOut('slow', function(){
        $('.dialog, .overlay').hide();
      });
    });
  }
}
