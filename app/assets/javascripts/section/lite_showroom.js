showroom = s = {} || null;

$(function(){
  s.init();
})

showroom = s = {

  init: function(){
    s.openModal();
    s.changeImage();
  },
  
  openModal: function(){
   if($('.dialog.liquidation').length == 1) {
     var content = $('.dialog.liquidation');
     o.newModal(content);
    }

    $(".dialog.liquidation :checkbox").live("change", function() {
      checked = $(this).is(":checked");
      $.post("/user_liquidations", { 'user_liquidation[dont_want_to_see_again]': checked });
    });
  },
  
  changeImage: function(){
    $("li.product ul li a.product_color").live("mouseenter", function() {
      $(this).parents("ul.color_list").find("li a").removeClass("selected");
      $(this).addClass("selected");
      productBox = $(this).parents(".box_product");
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
    hoverBox = $(color).parents("li.product").find(".hover_suggestive");
    spyLink = $(hoverBox).find("li.spy a").attr("href");
    $(hoverBox).find("li.spy a").attr("href", spyLink.replace(/\d+$/, productId));
  },
  
  updateProductImage: function(box, link, img) {
    $(box).find("a.product_link img").attr("src", img);
    $(box).find("a.product_link").attr("href", link);
  },

  
  isProductSoldOut: function(box, soldOut) {
    if(soldOut == "sold_out") {
      $(box).addClass("sold_out");
      return true;
    }
  }
  
}