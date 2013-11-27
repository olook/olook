var showInfoCredits = function() {
  $("a.open_loyalty_lightbox").live('click', function(e) {
    _gaq.push(['_trackEvent', 'product_show', 'show_loyalty_info', '']);
    content = $("div.credits_description");
    olook.newModal(content);
    e.preventDefault();
  });
};
