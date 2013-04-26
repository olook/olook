showroom = s = {} || null;

$(function(){
  s.init();
})

showroom = s = {

  init: function(){
    s.openModal();
    s.changeImage();
    s.replaceImages();
    s.modalEspiar();
    s.facebookCarousel();
    s.showProfile();
    s.attachFacebookShareCLick();
  },
  
  openModal: function(){
   if($('.dialog.liquidation').length == 1) {
     var content = $('.dialog.liquidation');
     o.newModal(content);
    }

    $(".dialog.liquidation :checkbox").on("change", function() {
      checked = $(this).is(":checked");
      $.post("/user_liquidations", { 'user_liquidation[dont_want_to_see_again]': checked });
    });

  },
  
  facebookCarousel: function(){

      $("div#mask_carousel_facebook ul").carouFredSel({
        auto: false,
        height: 45,
        width: 350,
        align: 'left',
        prev : {
          button : ".carousel-prev-fb"
        },
        next : {
          button : ".carousel-next-fb"
        }
      });
    
  },
  
  showProfile: function(){
    $(".description .show-profile").on("mouseenter",function() {
      $("img.profile-quiz").show();
    }).on("mouseleave", function() {
      $("img.profile-quiz").hide();
    });
  },
  
  changeImage: function(){
    $("li.product ul li a.product_color").on("mouseenter", function() {
      $(this).parents("ul.color_list").find("li a").removeClass("selected");
      $(this).addClass("selected");
      productBox = $(this).parents("li.product");
      quantityBox = $(productBox).find("a.product_link").find("p.quantity");
      newLink = $(this).attr("href");
      newImg = $(this).attr("data-href");
      soldOut = $(this).parent().find("input[type='hidden'].sold_out").val();
      quantity = $(this).parent().find("input[type='hidden'].quantity").val();
      $(productBox).removeClass("sold_out");
      $(productBox).removeClass("stock_down");

      s.updateProductImage(productBox, newLink, newImg);
  
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
  
  updateProductImage: function(box, link, img) {
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
      if(/http.*/.test(image))
        $(this).attr('src', image);
    });

  },

  attachFacebookShareCLick: function() {
    $('#facebook_share').click(postToFacebookFeed);
  }

}
