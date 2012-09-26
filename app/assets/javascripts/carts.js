$(function() {
  $("form#gift_message").bind("ajax:success", function(evt, xhr, settings) {
    document.location = $("a.continue").attr("href");
  });

  $(".continue").click(function() {
    $("form#gift_message").submit();
  })

  $("td.discount a.discount_percent").hover(function() {
    $(this).siblings('.discount_origin').css('display', 'table');
  }, function() {
    $(this).siblings('.discount_origin').hide();
  });

  $("table#coupon a#show_coupon_field").live("click", function(e) {
    $(this).hide();
    $(this).siblings("form").show();
    e.preventDefault();
  });

  $('section#cart a.continue.login').live('click', function(e) {
    clone = $('.dialog.product_login').clone().addClass("clone");
    content = clone[0].outerHTML;
    initBase.modal(content);
    e.preventDefault();
  });

  $('input#use_credit_value').change(function() {
    $('form#use_credit_form').submit();
  });


  $( "#gift_gift_wrap" ).change(function() {
    $( "#gift_wrap" ).submit();
    if ( $(this).attr('checked') == 'checked' ) {
      change_value (true);
    }
    else {
      change_value (false);
    }
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
});


function change_value(wrap) {
  wrap_value = $("form#gift_wrap").parent("td").next('td.value').text().match(/[0-9,]+/);
  wrap_value = parseFloat(wrap_value[0].replace( ",", "." ));

  actual_value = $('table#total tr.total td.value p:not(.limit)').text().match(/[0-9,]+/);
  actual_value = parseFloat(actual_value[0].replace( ",", "." ));

  new_value = actual_value + ((wrap) ? wrap_value : - wrap_value);
  $('table#total tr.total td.value').html("<p>R$ "+new_value.toFixed(2).toString().replace( ".", "," )+"</p>");
}
