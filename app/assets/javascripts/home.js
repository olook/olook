$(document).ready(function() {
  $("div#carousel ul").carouFredSel({
    auto: true,
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
