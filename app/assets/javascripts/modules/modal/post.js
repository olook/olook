var ModalPost  = (function(){
  function ModalPost() {};
  ModalPost.prototype.config = function(){
    olookApp.subscribe('modal:post', this.facade);
  };

  ModalPost.prototype.facade = function(email, element){
    $.post("/campaign_email_subscribe", {email: email})
    .done(function(data){
      element.click();
    })
    .fail(function(data) {
      console.log("FALHOOOOO" + data);
  });
  };
  return ModalPost;
})();
