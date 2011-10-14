$(document).ready(function() {

  function popupCenter(url, width, height, name) {
    var left = (screen.width/2)-(width/2);
    var top = (screen.height/2)-(height/2);

    return window.open(url, name, "menubar=no,toolbar=no,status=no,width=" + width + ",height=" + height + ",toolbar=no,left=" + left + ",top=" + top);

  }

  $("a.fbpopup").click(function(e) {
    e.stopPropagation();
    e.preventDefault();

    popupCenter($(this).attr("href"), $(this).attr("data-width"), $(this).attr("data-height"), "authPopup");

    return false;
  });

  $('.questions').jcarousel({
    scroll: 1
  });

});
