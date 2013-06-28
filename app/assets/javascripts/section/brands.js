$(document).ready(function() {
  $(".container-imgs ul").carouFredSel({
    auto: {
      duration: 1000
    },
    prev : {
      button : ".anterior",
      key : "left"
    },
    next : {
      button : ".proximo",
      key : "right"
    }
  });
});
