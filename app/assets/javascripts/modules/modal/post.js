var ModalPost  = (function(){
  function ModalPost() {};
  ModalPost.prototype.config = function(){
    olookApp.subscribe('modal:post', this.facade);
  };

  ModalPost.prototype.facade = function(email){
    $.post("/campaign_email_subscribe", function(){

    });
  };
  return ModalPost;
})();
