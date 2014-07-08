var ShippingRequest = (function(){

  function ShippingRequest() {
  };

  ShippingRequest.prototype.config = function(){
    olookApp.subscribe('shipping:request', this.facade, {}, this);
    $("#submit_zip_code").click(function(e){
      e.preventDefault();
      olookApp.publish("shipping:request", $("#zip_code").val());
    });
  };

  ShippingRequest.prototype.facade = function(cep){
    $.get("/display_free_shipping/"+cep+".json", {}).done(function(data){
      olookApp.publish("shipping:display_info", data);
    }).fail(function() {      
    });
  };
  return ShippingRequest;
})();

