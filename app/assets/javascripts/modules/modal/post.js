var ModalPost  = (function(){
  function ModalPost() {};
  ModalPost.prototype.config = function(){
    olookApp.subscribe('modal:post', this.facade);
  };

  ModalPost.prototype.facade = function(email, close_element, error_element){
    $.post("/campaign_email_subscribe", {email: email})
    .done(function(data){
      element.click();
    })
    .fail(function(data) {
      data = JSON.parse(data.responseText);
      error_element.html(data.message);
  });
  };
  return ModalPost;
})();
