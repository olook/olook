if(!olook) var olook = {};
olook.spy = function(selector){
  $(selector).click(function(e){
    e.preventDefault();
    var url = $(this).data('url');
    if(_gaq){
      var source = url.match(/from=(\w+)/);
      if(source){
        source = source[1];
      } else {
        source = 'Product';
      }
      _gaq.push(['_trackEvent', source, 'clickOnSpyProduct', url.replace(/\D/g, '')]);
    }
    $.ajax({
      url: url,
      cache: 'true',
      dataType: 'html',
      beforeSend: function() {
        var width = $(document).width(), height = $(document).height();
        $('#overlay-campaign').width(width).height(height).fadeIn();
        $('#ajax-loader').fadeIn();
      },
      success: function(dataHtml) {
        $('#ajax-loader').hide();

        initQuickView.inQuickView = true;

        if($("div#quick_view").size() == 0) {
          $("body").prepend("<div id='quick_view'></div>");
        }

        var width = $(document).width(), height = $(document).height();
        $('#overlay-campaign').width(width).height(height).fadeIn();

        var script = $(dataHtml).find('script:first').attr('src');

        $('#quick_view')
        .html(dataHtml)
        .css("top", $(window).scrollTop()  + 35)
        .fadeIn(100);

        $('#quick_view ol.colors li a').attr('data-remote', true);
        $("ul.social li.email").hide();


        $('#close_quick_view, #overlay-campaign').on("click", function() {
          $('#quick_view, #overlay-campaign').fadeOut(300);
        });
        if(typeof initProduct !== 'undefined') {
          initProduct.loadAddToCartForm();
        } else {
          $.getScript(script);
          $.getScript(script);
        }

        accordion();
        delivery();
        guaranteedDelivery();

        load_first_image();
        load_all_other_images();

        if (typeof initSuggestion != 'undefined') {
          initSuggestion.checkIfProductIsAlreadySelected();
        }
        initQuickView.productZoom();

        try{
          FB.XFBML.parse();
        }catch(ex){}
      },
      error: function() {
        window.location = url;
      }
    });
  }).mouseover(function() {
    var img = $(this).parent(".product").find("img");
    img.attr('src', img.data('backside-picture'));
  }).mouseout(function() {
    var img = $(this).parent(".product").find("img");
    img.attr('src', img.data('product'));
  });
};

$(function () {

  olook.spy('.spy[data-url]');

  $("#banner").click(function(){
    share();
  ;})

  var msie6 = $.browser == 'msie' && $.browser.version < 7;
  if(!msie6 && $('#help').length == 1) {
    var helpLeft = $('#help').offset().left;
    $(window).scroll(function(event) {
      var y = $(this).scrollTop();
      if(y >= 128) {
        $('#help').addClass('fixed').css('left', helpLeft);
      } else {
        $('#help').removeClass('fixed').css('left','');
      }
    });
  }

  $("section#profiles ul.models li a").live("click", function(e) {

    var profile = e.target.id;

    $("section#profile_products").hide();

    $("section#profiles ul li a").removeClass().addClass("off");
    $(this).removeClass("off").addClass('selected');

    $("section#profile_products." + profile).slideDown();
    var container_position = $("section#profile_products." + profile).offset().top - 40;
    InitGift.slideTo(container_position);

    $("section#profile_products." + profile + " div.content a#see_more")[0].href = "/presentes/profiles/" + profile

    e.preventDefault();
  });

  $("section#suggestions div.content ul.models li a").live("click", function(e) {
    var index = $(this).parent().index();
    $("section#suggestions div.content ul li").removeClass();
    $(this).parent().addClass("selected");
    if(index != 0) {
      var parent = $("section#suggestions div.content ul li")[index - 1];
      $(parent).addClass("no_border");
    } else {
      $("section#suggestions div.content ul li").removeClass("no_border");
    }
    $("section#suggestions_products").slideDown();
    var container_position = $("section#suggestions_products").offset().top - 40;
    InitGift.slideTo(container_position);
    InitGift.createLoader($("section#suggestions_products div.content"));
    e.preventDefault();
  });

  $("div.box.shoes ul li label").on("click", function(e) {

    // mark the checkbox next to this label, as checked
    $(this).next().attr("checked",true);

    $("div.box.shoes ul li").removeClass();
    $(this).parent().addClass("selected");
    e.preventDefault();
  });

  $("div#help p+a").on("click", function(e) {
    var container_position = $("section#quiz").offset().top;
    InitGift.slideTo(container_position);
    $(this).parent().fadeOut();
    e.preventDefault();
  });


  $("div#help a.close").on("click", function(e) {
    $(this).parent().fadeOut();
    e.preventDefault();
  });

  $("div#calendar ul#months li a").live("click", function(event) {
    $("div#calendar ul#months li a").removeClass("selected");
    $(this).addClass("selected");
    InitGift.friendsPreloader();
    event.preventDefault();
  });

  $("section#profile form ul.shoes li").live("click", function() {
    $("section#profile form ul.shoes li").removeClass("selected");
    $("section#profile form ul.shoes li label input[type='radio']").removeAttr("checked");
    $(this).find("label").find("input[type='radio']").attr("checked", "checked");
    if($(this).find("label").find("input[type='radio']").is(":checked")) {
      $(this).addClass("selected");
    }
  });

  $("section#profile a.select_profile").live("click", function(event) {
    $("section#profile div.profiles").slideDown('normal', function() {
      container_position = $(this).position().top;
      position = container_position - 40;
      $('html, body').animate({
        scrollTop: position
      }, 'slow');
    });
    event.preventDefault();
  });

  $("form.edit_profile ul li").click(function() {
    $(this).find("label").find("input[type='radio']").attr("checked", "checked");
    if($(this).find("label").find("input[type='radio']").is(":checked")) {
      $("form.edit_profile").submit();
    }
  });


});


InitGift = {

  friendsPreloader : function() {
    $("div#birthdays_list ul.friends_list").remove();
    $("div#birthdays_list").html("<div class='preloader'></div>");
  },

  slideTo : function(container_position) {
    position = container_position -40;
    $("html, body").animate({
      scrollTop: position
    }, 'normal');
  },

  createLoader : function(container) {
    $(container).html("<p class='loading'></p>");
  },
}

share = function() {
  var opt = {};
  // var coupon = "?coupon_code=" + $('#banner').data('couponCode');
  var sharer = location.href; //+ coupon;
  opt.method  = 'feed';
  opt.name = 'ACERTE EM CHEIO NO PRESENTE';
  opt.caption = 'Encontre o presente ideal para as mulheres da sua vida através da nossa ferramenta de presentes.';
  opt.description = '#ficaadica';
  opt.picture = 'http://d22zjnmu4464ds.cloudfront.net/assets/gift/imagem_presentes_facebook.jpg';
  opt.link = sharer;
  FB.ui(opt);
}

$(function () {
     $("a#scroll_to_quiz").click(function() {
      $('html, body').animate({
          scrollTop: $("#anchor_profile").offset().top
      }, 1500);
    });
  });
