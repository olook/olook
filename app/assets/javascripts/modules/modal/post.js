var ModalPost  = (function(){
  function ModalPost() {};
  ModalPost.prototype.config = function(){
    olookApp.subscribe('modal:post_email', this.facade);
  };

  ModalPost.prototype.facade = function(error_element){
    emailToBeSubmited = $('#js-emailValue').val();

    $.post('/campaign_email_subscribe', {email: emailToBeSubmited})
      .done(function(e) {
        log_event('action','newsletter-popup',{value: 'email'});
        $('#modal button.close').click();
      }).fail(function(data) {
      _data = JSON.parse(data.responseText);
      error_element.html(_data.message).css({'display':'block'});
    });

  };

  return ModalPost;
})();
