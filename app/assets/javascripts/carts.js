$(function() {

  $("form#gift_message").bind("ajax:success", function(evt, xhr, settings) {
    document.location = $("a.continue").attr("href");
  });

  $(".continue").click(function() {
    $("form#gift_message").submit();
  })

  $("#coupon a#show_coupon_field").live("click", function(e) {
    $(this).hide();
    $(this).siblings("form").show();
    e.preventDefault();
  });

  $('section#cart a.continue.login').live('click', function(e) {
    clone = $('.dialog.product_login').clone().addClass("clone");
    content = clone[0].innerHTML;
    initBase.modal(content);
    e.preventDefault();
  });

  $('#cart_use_credits').change(function() {
    $('#use_credit_form').submit();
  });

  $( "#cart_gift_wrap" ).change(function() {
    $( "#gift_wrap" ).submit();
  });

  $("#credits_credits_last_order").change(function() {
    $("#credits_last_order").submit();
  });

  $("table.check tbody tr td a").live("click", function(e) {
    clone = $('div.credit_details').clone().addClass("clone");
    content = clone[0].outerHTML;
    initBase.modal(content);
    e.preventDefault();
  });

  if($("div#carousel").size() > 0) {
    $("div#carousel ul.products_list").carouFredSel({
      auto: false,
      width: 760,
      items: {
        visible: 4
        },
      prev : {
        button : ".product-prev",
        items : 4
      },
      next : {
        button : ".product-next",
        items : 4
      }
    });
  }

  if($("div#carousel_lookbooks").size() > 0) {
    $("div#carousel_lookbooks ul").carouFredSel({
      auto: false,
      width: 970,
      items: 3,
      prev : {
        button : ".prev-lookbook",
        items : 1
      },
      next : {
        button : ".next-lookbook",
        items : 1
      },
      pagination: {
        container : "div#carousel_lookbooks .pagination",
        items : 1
      }
    });
  }
});

function changeCartItemQty(cart_item_id) {
  $('form#change_amount_' + cart_item_id).submit();
}