showroom = s = {} || null;

$(function(){
  s.init();
})

showroom = s = {

  init: function(){
    s.openModal();
    s.changeImage();
    s.changeImage();
    s.replaceImages();
    s.modalEspiar();
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
      s.spyLinkId($(this));
      s.updateProductImage(productBox, newLink, newImg);
  
      if(!s.isProductSoldOut(productBox, soldOut)) {
        s.checkProductQuantity(productBox, quantityBox, quantity);
      }
    });

  },
  
  spyLinkId: function(color) {
    productId = $(color).siblings(".product_id").val();
    hoverBox = $(color).parents("li.product");
    spyLink = $(hoverBox).find("a.spy").attr("href");
    $(hoverBox).find("a.spy").attr("href", spyLink.replace(/\d+$/, productId));
 
  },
  
  modalEspiar: function(){
    var _link;
    $("li.product a.spy").on("mouseenter", function(){
      _link = $(this).attr('href');
      
    }).on("click", function(){
      $(this).attr('href', '#');
      $("#modal").append('<iframe width="1000" height="735" src="http://olook.com.br'+_link +'">').fadeIn();

    });
    
    if($("div#quick_view").size() == 0) {
      $("body").prepend("<div id='quick_view'></div>");
    }
    

    $('#close_quick_view, div.overlay').on("click", function() {
      $('#quick_view').fadeOut(300);
      $("div.overlay").remove();
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

  }
  
}