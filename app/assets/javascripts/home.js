$(document).ready(function() {
  $("div#carousel ul").carouFredSel({
    auto: {
      duration: 1000
    },
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
