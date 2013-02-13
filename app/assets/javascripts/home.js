$(document).ready(function() {
  $("div#carousel ul").carouFredSel({
    auto: false,
    prev : {
      button : ".prev-item",
      key : "left"
    },
    next : {
      button : ".next-item",
      key : "right"
    }
  });
});
