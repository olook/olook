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
    var value = $('#total_value').text().replace("R$ ", "")
    $.get("/api/v1/freights?zip_code="+cep+"&amount_value="+value, {}).done(function(data){
      olookApp.publish("shipping:display_info", data[0]);
    }).fail(function() {
    });
  };
  return ShippingRequest;
})();

