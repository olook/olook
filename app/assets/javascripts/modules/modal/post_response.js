var ModalPostResponse  = (function(){
  function ModalPostResponse() {};
  ModalPostResponse.prototype.config = function(){
    olookApp.subscribe('modal:post_response', this.facade);
  };

  ModalPostResponse.prototype.facade = function(error_element){
    $("#campaign_email_form").on("ajax:success", function(e, data, status, xhr) {
      log_event('action','newsletter-popup',{value: 'email'})
      $('#modal button.close').click();
    }).on("ajax:error", function(e, xhr, status, error) {
      _data = JSON.parse(xhr.responseText);
      error_element.html(_data.message).css({'display':'block'});
    });

  };
  return ModalPostResponse;
})();
