// Luhn algorithm validator, by Avraham Plotnitzky.
var LuhnCheck = (function()
{
	var luhnArr = [0, 2, 4, 6, 8, 1, 3, 5, 7, 9];
	return function(str)
	{
		var counter = 0;
		var incNum;
		var odd = false;
		var temp = String(str).replace(/[^\d]/g, "");
		if ( temp.length == 0)
			return false;
		for (var i = temp.length-1; i >= 0; --i)
		{
			incNum = parseInt(temp.charAt(i), 10);
			counter += (odd = !odd)? incNum : luhnArr[incNum];
		}
		if ((counter%10 == 0) === false){
			$(".credit_card_number .span-error").text('').text('Número de cartão inválido');
			$(".credit_card_number input").addClass("credit-error");
			$("input.finish").attr('disabled','disabled')
		}else{
			$(".credit_card_number .span-error").text('');
			$(".credit_card_number input").removeClass("credit-error");
			$("input.finish").removeAttr('disabled')
		}
		
	}
})();

/* FACEBOOK POPUP */
function popupCenter(url, width, height, name) {
  var left = (screen.width/2)-(width/2), top = (screen.height/2)-(height/2), popupValue = "on";
  return window.open(url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top);
}
 

$(document).ready(function() {
	
	$("a.popup").click(function(e) {
	  popupCenter($(this).attr("href"), $(this).attr("data-width"), $(this).attr("data-height"), "authPopup");
	  e.stopPropagation(); return false;
	});
	if(window.opener && window.opener.popupValue === 'on') {
	 delete window.opener.popupValue;
	 window.opener.location.reload(true);
	 window.close(); 
	}
	
  initBase.dialogLogin();
  initBase.loadJailImages();
  initBase.customSelect();
  initBase.showErrorMessages();
  initBase.fixBorderOnMyAccountDropDown();
  initBase.openMakingOfVideo();
  initBase.showInfoCredits();
  initBase.showSlideToTop();
  initBase.slideToTop();

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

  $('div#session ul li.credits > a').live('click', function(e) {
    e.preventDefault();
  });

  $('div#session ul li.credits').hover(function() {
    $('div#session ul li.credits > a').addClass('hover');
    $(this).find('#credits_info').show();
  }, function() {
    $('div#session ul li.credits > a').removeClass('hover');
    $(this).find('#credits_info').hide();
  });

  $("div.box_invite.clone div.social ul li a").live("click", function() {
    type = $(this).parent().attr("class");
    if(type != "email") {
      $("div.box_invite.clone div.social ul li a").removeClass("selected");
      $("div.box_invite.clone div.social form").slideUp();
    } else {
      $(this).addClass("selected");
      $("div.box_invite.clone div.social form").slideDown();
      $("html, body").animate({
        scrollTop: "200px"
      }, 'slow');
      return false;
    }
  });

  $("div.box_invite.clone div.social ul li.twitter a, div.social ul li.twitter a").live("click", function(e) {
    var width  = 575,
        height = 400,
        left   = ($(window).width()  - width)  / 2,
        top    = ($(window).height() - height) / 2,
        url    = this.href,
        opts   = 'status=1' +
                 ',width='  + width  +
                 ',height=' + height +
                 ',top='    + top    +
                 ',left='   + left;

    window.open(url, 'twitter', opts);
    e.preventDefault();
  });

  $("li.product div.hover_suggestive ul li.spy a, li div.product-map a").live("click", function() {
    if($("div#quick_view").size() == 0) {
      $("body").prepend("<div id='quick_view'></div>");
    }
  });

  $('#close_quick_view, div.overlay').live("click", function() {
    $('#quick_view').fadeOut(300);
    $("div.overlay").remove();
  });

  $("ol.addresses li.address_item ul.links li a.select_address").live("click", function() {
    if($(this).parents("li.address_item").hasClass("add") == false) {
      lists = $(this).parents("ol").find("li");
      lists.find("input").attr('checked', false);
      lists.removeClass("selected");
      set_price_for_zipcode($(this).attr('data'));
      $(this).parents("li.address_item").find('input').attr('checked', true);
      $(this).parents("li.address_item").addClass('selected');
      return false;
    }
  });

  $("#facebook_invite_friends").click(function(event) {
    event.preventDefault();
    sendFacebookMessage();
  });

  $("#facebook_post_wall").live("click", function() {
    postToFacebookFeed();
    return false;
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

  $("input:text.zip_code").setMask({
    mask: '99999-999'
  });

  var set_price_for_zipcode = function(zipcode){
    if (zipcode.length < 9) {
      return true;
    }
    if ($("#request_info").size() > 0) {
      $.getScript("/sacola/pagamento/preview_by_zipcode?zipcode=" + zipcode);
    }
  };

  $("input#address_zip_code").focusout(function(){
    set_price_for_zipcode($("input#address_zip_code").val());
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
        $('form input#address_number, form input#address_complement').val('');
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

  // For now both fone field will acept nine digits
  $("input:text.phone").keyup(function(){
		ddd  = $(tel).val().substring(1, 3);
		dig9 = $(tel).val().substring(5, 6);
		if(ddd == "11" && dig9 == "9")
			$(tel).setMask("(99) 99999-9999");
	  else
	    $(tel).setMask("(99) 9999-9999");	  
	}).focus(function(){
	    $(tel).unsetMask();
	}).focusout(function() {
			ddd  = $(tel).val().substring(1, 3);
			dig9 = $(tel).val().substring(5, 6);
	    if(ddd == "11" && dig9 == "9")
				$(tel).setMask("(99) 99999-9999");
		  else
		    $(tel).setMask("(99) 9999-9999");
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
	
	// VALIDATION EXCEPTION - HIPERCARD
	$("#credit_card_bank_Hipercard").click(function(){
		if($("input:text.credit_card").hasClass("credit-error")){
			$("input:text.credit_card").removeClass("credit-error");
			$(".credit_card_number .span-error").text('');
		}
	})
	
  $("input:text.credit_card")
		.focusout(function(){
			val = $(this).val();
			hipercard = $("#credit_card_bank_Hipercard").is(":checked");
			if(!hipercard){
				LuhnCheck(val);
			}
		})
		.setMask({
    	mask: '9999999999999999999'
  	});

  $("fieldset.banks ol li input[type='radio']").change(function() {
    var flag = $(this).val();
    if(flag == "Hipercard") {
      $("input:text.credit_card").setMask({
        mask: '9999999999999999999'
      });
    } else {
      $("input:text.credit_card").setMask({
        mask: '9999999999999999'
      });
    }
  });


  $("input:text.security_code").setMask({
    mask: '9999'
  });

  $(".form_amount").change(function(){
    $(this).submit();
  });

  $("div#wrapper_menu nav.menu ul li a.cart, ul.submenu").live("mouseenter", function() {
    $(this).parent("li").find("ul").show();
    $("body").addClass('cart_submenu_opened');
  }).live("mouseleave", function() {
    $(this).parent("li").find("ul").hide();
    $("body").removeClass('cart_submenu_opened');
  });

  $("ul.submenu li form.delete").live("ajax:success", function(evt, xhr, settings){
    var defaultQuantity = 1;
    var items = parseInt($("#cart_items").text());
    var newItems = items - defaultQuantity;
    $("#cart_items").text(newItems <= 0 ? 0 : newItems);
    $(this).parent("li.product_item").fadeOut("slow", function() {
      $(this).remove();
    });
    if(newItems <= 0) {
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
    initBase.spyLinkId($(this));
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

  $("div#mask_carousel_showroom ul li a.video_link, div#carousel_lookbooks_product a.video_link, div#carousel_lookbooks a.video_link").live("click", function(e) {
    var url = $(this).attr("rel");
    var title = $("<div>").append($(this).siblings(".video_description").clone()).remove().html();
    var youtube_id = initBase.youtubeParser(url);
    content = initBase.youtubePlayer(youtube_id);
    content += title;
    initBase.modal(content);
    e.preventDefault();
  });

  $("section#greetings div.facebook div.profile a").live("click", function(e) {
    initBase.showProfileLightbox();

    container = $('div#profile_quiz.clone img');
    profile = container.attr('class');
    container.attr('src', 'http://cdn-app-staging-0.olook.com.br/assets/profiles/big_'+profile+'.jpg');
    
    e.preventDefault();
  });

  $(".ui-widget-overlay, div#profile_quiz ul li a.close").live("click", function(e) {
    $("div#modal").dialog("close");
    e.preventDefault();
  });

  $("li.cart div.warn a.close").on("click", function(e) {
    $(this).parent().fadeOut();
    e.preventDefault();
  });
});

initBase = {
  showErrorMessages : function() {
    if( error = $('#error-messages').html() ){
      if( error.length >= '73' ){
        $('.alert').parent().slideDown('1000', function() {
          $('.alert').parent().delay(5000).slideUp();
        })
      }
    }
  },

  showProfileLightbox : function() {
    clone = $("div#profile_quiz").clone().addClass("clone");
    content = clone[0].outerHTML;
    initBase.modal(content);
    $(".ui-dialog").css("top", "30px");
  },

  spyLinkId : function(color) {
    productId = $(color).siblings(".product_id").val();
    hoverBox = $(color).parents("li.product").find(".hover_suggestive");
    spyLink = $(hoverBox).find("li.spy a").attr("href");
    $(hoverBox).find("li.spy a").attr("href", spyLink.replace(/\d+$/, productId));
  },

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
    $("div#modal").html("");

    $("div#modal").prepend(content);

    $("div#modal").dialog({
      width: 'auto',
      resizable: false,
      draggable: false,
      modal: true,
      close: function(event) {
        $("div#modal").html("");
        $("div#modal").hide();
      }
    });
  },

  showInfoCredits : function() {
    $("a.open_loyalty_lightbox").live('click', function(e) {
      clone = $("div.credits_description").clone().addClass("clone");
      content = clone[0].outerHTML;
      initBase.modal(content);
      e.preventDefault();
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
  },

  fixBorderOnMyAccountDropDown : function() {
    $('#session div.user ul li.submenu').hover(function() {
      var link = $(this).find('a#info_user');
      if($(link).outerWidth() >= '125') {
        var link_width = $(link).outerWidth();
      } else {
        var link_width = 125;
      }
      $(this).find('div.my_account').css('width', link_width - 4);
      $(link).addClass('hover');
    }, function() {
      var link = $(this).find('a#info_user');
      $(link).removeClass('hover');
    });
  },

  openMakingOfVideo : function() {
    $("section.making_of a.open_making_of, div#making_of a").live("click", function(e) {
      var url = $(this).attr("rel");
      var title = $("<div>").append($(this).siblings(".video_description").clone()).remove().html();
      var youtube_id = initBase.youtubeParser(url);
      content = initBase.youtubePlayer(youtube_id);
      content += title;
      initBase.modal(content);
      e.preventDefault();
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
    $('a#go_top').live('click', function(e) {
      $("html, body").animate({
        scrollTop: 0
      }, 'fast');
      e.preventDefault();
    });
  }
}
