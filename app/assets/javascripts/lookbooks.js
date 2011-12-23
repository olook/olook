$(document).ready(function() {
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
    }
  });

  $("div#carousel_lookbooks_product ul").carouFredSel({
    auto: false,
    prev : {
      button : ".prev-pic",
      key : "left"
    },
    next : {
      button : ".next-pic",
      key : "right"
    }
  });
});
