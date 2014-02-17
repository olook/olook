function DiscountPriceUpdater(opts) {
  this.product_ids = opts['product_ids'];
  this.prices = {};
}

DiscountPriceUpdater.prototype.getPrices = function() {
  var me = this;
  $.ajax({
    url: '/api/prices.json',
    data: { product_ids: this.product_ids }
  }).success(function(data){
    me.prices = data['prices'];
    me.replaceUpdatedPrices();
  });
}

DiscountPriceUpdater.prototype.replaceUpdatedPrices = function() {
  for( var product_id in this.prices ) {
    var li = $('li[data-id="' + product_id + '"]');
    li.find('.price').remove();
    var html = '<span class=\'price\'>\n  <span class=\'old\' itemprop=\'price\'>\n    De __OLD__\n  <\/span>\n  <span class=\'txt-pink\' itemprop=\'offers\'>\n    &nbsp;por __NEW__\n  <\/span>\n<\/span>\n';
    var values = this.prices[product_id];
    li.find('.info-product').append(html.replace(/__OLD__/g, values['de']).replace(/__NEW__/g, values['por']));
  }
}

if(!olook) olook = {};
olook.priceUpdater = function() {
  var product_ids = $('.product').map(function(idx, item){ return $(item).data('id'); }).get().join(',');
  var dpu = new DiscountPriceUpdater({ product_ids: product_ids });
  dpu.getPrices();
}
;
