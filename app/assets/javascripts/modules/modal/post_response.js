var ModalPostResponse  = (function(){
  function ModalPostResponse() {};
  ModalPostResponse.prototype.config = function(){
    olookApp.subscribe('modal:post_response', this.facade);
  };

  ModalPostResponse.prototype.facade = function(email, close_element, error_element){
    $("#campaign_email_form").on("ajax:success", function(e, data, status, xhr) {
      return $('#modal button.close').click();
    }).on("ajax:error", function(e, xhr, status, error) {
      _data = JSON.parse(xhr.responseText);
      return $('.modal_error').html(_data.message).css('display:block');
    });
  };
  return ModalPostResponse;
})();
