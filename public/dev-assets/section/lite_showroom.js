if(!olook) var olook = {};

olook.newModal = function(content, a, l, backgroud_color){
  var $modal = $("div#modal.promo-olook"),
  h = a > 0 ? a : $("img",content).outerHeight(),
  w = l > 0 ? l : $("img",content).outerWidth(),
  ml = -parseInt((w/2)),
  mt = -parseInt((h/2)),
  heightDoc = $(document).height(),
  _top = Math.max(0, (($(window).height() - h) / 2) + $(window).scrollTop()),
  _left=Math.max(0, (($(window).width() - w) / 2) + $(window).scrollLeft());
  backgroud_color = backgroud_color || "#000";

  $("#overlay-campaign").css({"background-color": backgroud_color, 'height' : heightDoc}).fadeIn().bind("click", function(){
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
    'margin-top'  : mt,
    'border-bottom': '1px solid #000'

  })
  .append('<button type="button" class="close" role="button">close</button>')
  .delay(500).fadeIn().children().show();



  $("button.close, #modal a.me").click(function(){
    _iframe = $modal.contents().find("iframe");
    if (_iframe.length > 0){
      $(_iframe).remove();
    }

    $("button.close").remove();
    $modal.fadeOut();
    $("#overlay-campaign").fadeOut();
  })

};
showroom = s = {} || null;

$(function(){
  s.init();
});

showroom = s = {

  init: function(){
    s.openModal();
    s.changeImage();
    s.replaceImages();
    s.modalEspiar();
    s.facebookCarousel();
    s.showProfile();
    s.attachFacebookShareCLick();
    s.showModalProfile();
    s.setMouseOverOnImages();
  },

  openModal: function(){
   if($('.dialog.liquidation').length == 1) {
     var content = $('.dialog.liquidation');
     o.newModal(content, 550, 550);
    }
  },

  facebookCarousel: function(){
    if($("#friends-face").length > 0){
      $("#friends-face").carouFredSel({
        auto  : false,
        prev  : "#prev-button",
        next  : "#next-button",
        items	: {
        	width	 : 55,
        	height : 55
        }
      });
    }
  },

  showProfile: function(){
    $(".description .show-profile, img.profile-quiz").on("mouseenter", function() {
      $("img.profile-quiz").show();
    }).on("mouseleave", function() {
      $("img.profile-quiz").hide();
    });
  },

  showModalProfile: function(){
    $("img.profile-quiz, a.show-profile").on("click", function(e){
      container = $('div#profile_quiz img');
      profile = container.attr('class');
      container.attr('src', 'http://cdn-app-staging-0.olook.com.br/assets/profiles/big_'+profile+'.jpg');

      var content = $("div.box-profile");
      var clone = content.clone().addClass('clone');

      $("#showroom").append(clone);

      o.newModal(content,546,930);
      e.preventDefault();
    })
  },

  changeImage: function(){
    $("li.product ul li a.product_color").on("mouseenter", function() {
      $(this).parents("ul.color_list").find("li a").removeClass("selected");
      $(this).addClass("selected");
      productBox = $(this).parents("li.product");
      quantityBox = $(productBox).find("a.product_link").find("p.quantity");
      newLink = $(this).attr("href");
      newImg = $(this).attr("data-href");
      newBackImg = $(this).attr("data-back-href");
      newProductImg = $(this).attr("data-product");
      soldOut = $(this).parent().find("input[type='hidden'].sold_out").val();
      quantity = $(this).parent().find("input[type='hidden'].quantity").val();
      $(productBox).removeClass("sold_out");
      $(productBox).removeClass("stock_down");

      s.updateProductImage(productBox, newLink, newImg, newBackImg, newProductImg);

      if(!s.isProductSoldOut(productBox, soldOut)) {
        s.checkProductQuantity(productBox, quantityBox, quantity);
      }
    });
  },

  modalEspiar: function(){
    $("li.product a.spy").click(function(e){
      e.preventDefault();
      var _link = $(this).data('href');
      $("div#overlay-campaign").css("height", $(document).height()).fadeIn();

      $("#modal")
      .append('<iframe width="1000" border="0" height="735" src="'+_link+'">').css("top", $(window).scrollTop()  + 35)
      .append('<div id="close_quick_view">x</div>')
      .fadeIn();
    });


    $('#close_quick_view, div#overlay-campaign').on("click", function() {
      $('#modal, div#overlay-campaign').fadeOut(300);
      $("#modal").html('');
    });
  },

  updateProductImage: function(box, link, img, back_img, prod_img) {
    $(box).find("a.product_link img").attr("data-product", prod_img);
    $(box).find("a.product_link img").attr("data-backside", back_img);
    $(box).find("a.product_link img").attr("src", img);
    $(box).find("a.product_link").attr("href", link);
  },

  checkProductQuantity : function(productBox, quantityBox, quantity) {
    if(quantity > 0 && quantity <= 3) {
      $(quantityBox).find("span").text(quantity);
      $(productBox).addClass("stock_down");
    }
  },

  isProductSoldOut: function(box, soldOut) {
    if(soldOut == "sold_out") {
      $(box).addClass("sold_out");
      return true;
    }
  },

  replaceImages: function(imageKind){
    if(typeof imageKind == 'undefined') imageKind = 'showroom';
    $('img.async').each(function(){
      var image = $(this).data(imageKind);
      $(this).attr('src', image);
    });

  },

  attachFacebookShareCLick: function() {
    if(typeof postToFacebookFeed !== 'undefined')
      $('#facebook_share').click(postToFacebookFeed);
  },

  setMouseOverOnImages: function() {
    $('img.async').on('mouseenter', function () {
      var backside_image = $(this).attr('data-backside');
      $(this).attr('src', backside_image);
      }).on('mouseleave', function () {
        var field_name = 'data-product';
        var showroom_image = $(this).attr(field_name);
        $(this).attr('src', showroom_image);
      });
  }
}
;
