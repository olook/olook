brands = b = {} || null;

brands = b = {
  init: function(){
    b.changeText();
    b.selectedFilter();
    //b.hideFilterByBody();
  },
  
  changeText: function(){
    $(".filter select").each(function(){
      $(this).change(function(){
        var txt = $('option:selected', this).text();
        $(this).prev().text(txt);
      })
    })
  },
  
  selectedFilter: function(){
    var txt = $("span.txt-filter");
    txt.each(function(){ 
      $(this).on("click", function(){
        $(this).parent().siblings().find("ul, .tab_bg").hide();
        $(this).parent().siblings().find("span.txt-filter.clicked").removeClass("clicked");
        $(this).toggleClass('clicked').siblings().toggle();
      })
    })
    
  },
  
  hideFilterByBody: function(){
    $("html").on("click", function(){
      if($(".filter ul").is(":visible")){
        $(".filter ul:visible, .filter .tab_bg:visible").hide();
        $(".fiilter span.txt-filter.clicked").removeClass("clicked");
      }
    });
  }
}

$(document).ready(function() {
  b.init();
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

