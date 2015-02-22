var showInfoCredits = function() {
  return false;
  $("a.open_loyalty_lightbox").live('click', function(e) {
    _gaq.push(['_trackEvent', 'product_show', 'show_loyalty_info', '']);
    var content = $("div.credits_description");
    olook.newModal(content, 450, 800, '#fff');
    e.preventDefault();
  });
};
