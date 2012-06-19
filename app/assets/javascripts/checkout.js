$(function() {
  $("div#container_marcos p a").live("click", function(e) {
    var clone = $("div#container_marcos div#rules").clone().addClass("clone");
    var content = clone[0].outerHTML;
    initBase.modal(content);
    e.preventDefault();
  });
});

