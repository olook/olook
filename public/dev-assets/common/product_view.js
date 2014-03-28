/*jslint bitwise: true, nomen: true, plusplus: true, white: true */

/*!
* Mediator.js Library v0.9.6
* https://github.com/ajacksified/Mediator.js
*
* Copyright 2013, Jack Lawson
* MIT Licensed (http://www.opensource.org/licenses/mit-license.php)
*
* For more information: http://thejacklawson.com/2011/06/mediators-for-modularized-asynchronous-programming-in-javascript/index.html
* Project on GitHub: https://github.com/ajacksified/Mediator.js
*
* Last update: October 19 2013
*/


(function(global, factory) {
  'use strict';

  if(typeof exports !== 'undefined') {
    // Node/CommonJS
    exports.Mediator = factory();
  } else if(typeof define === 'function' && define.amd) {
    // AMD
    define('mediator-js', [], function() {
      global.Mediator = factory();
      return global.Mediator;
    });
  } else {
    // Browser global
    global.Mediator = factory();
  }
}(this, function() {
  'use strict';

  // We'll generate guids for class instances for easy referencing later on.
  // Subscriber instances will have an id that can be refernced for quick
  // lookups.

  function guidGenerator() {
    var S4 = function() {
       return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
    };

    return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4());
  }

  // Subscribers are instances of Mediator Channel registrations. We generate
  // an object instance so that it can be updated later on without having to
  // unregister and re-register. Subscribers are constructed with a function
  // to be called, options object, and context.

  function Subscriber(fn, options, context){
    if(!(this instanceof Subscriber)) {
      return new Subscriber(fn, options, context);
    }

    this.id = guidGenerator();
    this.fn = fn;
    this.options = options;
    this.context = context;
    this.channel = null;
  }

  Subscriber.prototype = {
    // Mediator.update on a subscriber instance can update its function,context,
    // or options object. It takes in an object and looks for fn, context, or
    // options keys.

    update: function(options){
      if(options){
        this.fn = options.fn || this.fn;
        this.context = options.context || this.context;
        this.options = options.options || this.options;
        if(this.channel && this.options && this.options.priority !== undefined) {
            this.channel.setPriority(this.id, this.options.priority);
        }
      }
    }
  };


  function Channel(namespace, parent){
    if(!(this instanceof Channel)) {
      return new Channel(namespace);
    }

    this.namespace = namespace || "";
    this._subscribers = [];
    this._channels = [];
    this._parent = parent;
    this.stopped = false;
  }

  // A Mediator channel holds a list of sub-channels and subscribers to be fired
  // when Mediator.publish is called on the Mediator instance. It also contains
  // some methods to manipulate its lists of data; only setPriority and
  // StopPropagation are meant to be used. The other methods should be accessed
  // through the Mediator instance.

  Channel.prototype = {
    addSubscriber: function(fn, options, context){
      var subscriber = new Subscriber(fn, options, context);

      if(options && options.priority !== undefined){
        // Cheap hack to either parse as an int or turn it into 0. Runs faster
        // in many browsers than parseInt with the benefit that it won't
        // return a NaN.
        options.priority = options.priority >> 0;

        if(options.priority < 0){ options.priority = 0; }
        if(options.priority >= this._subscribers.length){ options.priority = this._subscribers.length-1; }

        this._subscribers.splice(options.priority, 0, subscriber);
      }else{
        this._subscribers.push(subscriber);
      }

      subscriber.channel = this;

      return subscriber;
    },

    // The channel instance is passed as an argument to the mediator subscriber,
    // and further subscriber propagation can be called with
    // channel.StopPropagation().
    stopPropagation: function(){
      this.stopped = true;
    },

    getSubscriber: function(identifier){
      var x = 0,
          y = this._subscribers.length;

      for(x, y; x < y; x++){
        if(this._subscribers[x].id === identifier || this._subscribers[x].fn === identifier){
          return this._subscribers[x];
        }
      }
    },

    // Channel.setPriority is useful in updating the order in which Subscribers
    // are called, and takes an identifier (subscriber id or named function) and
    // an array index. It will not search recursively through subchannels.

    setPriority: function(identifier, priority){
      var oldIndex = 0,
          x = 0,
          sub, firstHalf, lastHalf, y;

      for(x = 0, y = this._subscribers.length; x < y; x++){
        if(this._subscribers[x].id === identifier || this._subscribers[x].fn === identifier){
          break;
        }
        oldIndex ++;
      }

      sub = this._subscribers[oldIndex];
      firstHalf = this._subscribers.slice(0, oldIndex);
      lastHalf = this._subscribers.slice(oldIndex+1);

      this._subscribers = firstHalf.concat(lastHalf);
      this._subscribers.splice(priority, 0, sub);
    },

    addChannel: function(channel){
      this._channels[channel] = new Channel((this.namespace ? this.namespace + ':' : '') + channel, this);
    },

    hasChannel: function(channel){
      return this._channels.hasOwnProperty(channel);
    },

    returnChannel: function(channel){
      return this._channels[channel];
    },

    removeSubscriber: function(identifier){
      var x = this._subscribers.length - 1;

      // If we don't pass in an id, we're clearing all
      if(!identifier){
        this._subscribers = [];
        return;
      }

      // Going backwards makes splicing a whole lot easier.
      for(x; x >= 0; x--) {
        if(this._subscribers[x].fn === identifier || this._subscribers[x].id === identifier){
          this._subscribers[x].channel = null;
          this._subscribers.splice(x,1);
        }
      }
    },

    // This will publish arbitrary arguments to a subscriber and then to parent
    // channels.

    publish: function(data){
      var x = 0,
          y = this._subscribers.length,
          called = false,
          subscriber, l,
          subsBefore,subsAfter;

      // Priority is preserved in the _subscribers index.
      for(x, y; x < y; x++) {
        if(!this.stopped){
          subscriber = this._subscribers[x];
          if(subscriber.options !== undefined && typeof subscriber.options.predicate === "function"){
            if(subscriber.options.predicate.apply(subscriber.context, data)){
              subscriber.fn.apply(subscriber.context, data);
              called = true;
            }
          }else{
            subsBefore = this._subscribers.length;
            subscriber.fn.apply(subscriber.context, data);
            subsAfter = this._subscribers.length;
            y = subsAfter;
            if (subsAfter === subsBefore - 1){
              x--;              
            }
            called = true;
          }
        }

        if(called && subscriber.options && subscriber.options !== undefined){
          subscriber.options.calls--;

          if(subscriber.options.calls < 1){
            this.removeSubscriber(subscriber.id);
            y--;
            x--;
          }
        }
      }

      if(this._parent){
        this._parent.publish(data);
      }

      this.stopped = false;
    }
  };

  function Mediator() {
    if(!(this instanceof Mediator)) {
      return new Mediator();
    }

    this._channels = new Channel('');
  }

  // A Mediator instance is the interface through which events are registered
  // and removed from publish channels.

  Mediator.prototype = {

    // Returns a channel instance based on namespace, for example
    // application:chat:message:received

    getChannel: function(namespace){
      var channel = this._channels,
          namespaceHierarchy = namespace.split(':'),
          x = 0, 
          y = namespaceHierarchy.length;

      if(namespace === ''){
        return channel;
      }

      if(namespaceHierarchy.length > 0){
        for(x, y; x < y; x++){

          if(!channel.hasChannel(namespaceHierarchy[x])){
            channel.addChannel(namespaceHierarchy[x]);
          }

          channel = channel.returnChannel(namespaceHierarchy[x]);
        }
      }

      return channel;
    },

    // Pass in a channel namespace, function to be called, options, and context
    // to call the function in to Subscribe. It will create a channel if one
    // does not exist. Options can include a predicate to determine if it
    // should be called (based on the data published to it) and a priority
    // index.

    subscribe: function(channelName, fn, options, context){
      var channel = this.getChannel(channelName);

      options = options || {};
      context = context || {};

      return channel.addSubscriber(fn, options, context);
    },

    // Pass in a channel namespace, function to be called, options, and context
    // to call the function in to Subscribe. It will create a channel if one
    // does not exist. Options can include a predicate to determine if it
    // should be called (based on the data published to it) and a priority
    // index.

    once: function(channelName, fn, options, context){
      options = options || {};
      options.calls = 1;

      return this.subscribe(channelName, fn, options, context);
    },

    // Returns a subscriber for a given subscriber id / named function and
    // channel namespace

    getSubscriber: function(identifier, channel){
      return this.getChannel(channel || "").getSubscriber(identifier);
    },

    // Remove a subscriber from a given channel namespace recursively based on
    // a passed-in subscriber id or named function.

    remove: function(channelName, identifier){
      this.getChannel(channelName).removeSubscriber(identifier);
    },

    // Publishes arbitrary data to a given channel namespace. Channels are
    // called recursively downwards; a post to application:chat will post to
    // application:chat:receive and application:chat:derp:test:beta:bananas.
    // Called using Mediator.publish("application:chat", [ args ]);

    publish: function(channelName){
      var args = Array.prototype.slice.call(arguments, 1),
          channel = this.getChannel(channelName);

      args.push(channel);

      this.getChannel(channelName).publish(args);
    }
  };

  // Alias some common names for easy interop
  Mediator.prototype.on = Mediator.prototype.subscribe;
  Mediator.prototype.bind = Mediator.prototype.subscribe;
  Mediator.prototype.emit = Mediator.prototype.publish;
  Mediator.prototype.trigger = Mediator.prototype.publish;
  Mediator.prototype.off = Mediator.prototype.remove;

  // Finally, expose it all.

  Mediator.Channel = Channel;
  Mediator.Subscriber = Subscriber;
  Mediator.version = "0.9.6";

  return Mediator;
}));
  





/* A classe-namespace. Objetos desta classe devem conter a instancia do mediator.
 * Alternativamente, podemos tambem criar metodos que tem como objetivo desacoplar o codigo de bibliotecas de manipulacao de
 * DOM e chamadas AJAX (ex.: jQuery)
 */

var OlookApp = (function() {
  function OlookApp(_mediator) {
    this.mediator = _mediator;
  };

  var shift = function(list, starting_point) {
    return Array.prototype.slice.call(list, starting_point);
  };

  OlookApp.prototype.publish = function() {
    if (arguments.length == 0){
      throw "channel name is required";
    }
    console.log('mediator ' + arguments[0] + ' fired');
    this.mediator.publish.apply(this.mediator, arguments);
  };

  OlookApp.prototype.subscribe = function() {
    if (arguments.length == 0){
      throw "channel name is required";
    } else if (arguments.length == 1){
      throw "channel facade method is required";
    }
    var options = (arguments.length >= 3) ? arguments[2] : null;
    var context = (arguments.length >= 4) ? arguments[3] : null;
    console.log('mediator ' + arguments[0] + ' subscribed by ' + arguments[1]);
    this.mediator.subscribe(arguments[0], arguments[1], options, context);
  };

  return OlookApp;
})();

var olookApp = new OlookApp(new Mediator());
window.onscroll = function() {
  olookApp.mediator.publish('window:onscroll');
}
;
StringUtils = {
  isEmpty: function(str){
    return !(str && str!=''); 
  },
  capitalize: function(str) {
    return this.charAt(0).toUpperCase() + this.slice(1);
  }  
};

String.prototype.isEmpty = StringUtils.isEmpty;

String.prototype.capitalize = StringUtils.capitalize;
var AddToWishlist = (function(){
  function AddToWishlist(){};

  AddToWishlist.prototype.facade = function(productId) {

    var action_url = '/wished_products';

    var element = $('[name="variant[id]"]:checked');
    if (element.size() == 0) {
      olookApp.publish("wishlist:add:error_message", "Qual é o seu tamanho mesmo?");
    } else {
      var values = {'variant_id': element.val()}
      $.post(action_url, values, function(data) {
          olookApp.publish("wishlist:add:success_message", data.message);
        }).fail(function(data){
          if (data.status == 401) {//non authorized
            window.location.href='/entrar/1';
          }
        });
    }
  };

  AddToWishlist.prototype.config = function(){
    olookApp.subscribe('wishlist:add:click_button', this.facade, {}, this);
  };

  return AddToWishlist;
})();
var AddToWishlistErrorMessage = (function(){

  function AddToWishlistErrorMessage(){};

  AddToWishlistErrorMessage.prototype.facade = function(message) {
    $('p.alert_size').html(message).show()
      .delay(3000).fadeOut();    
  };

  AddToWishlistErrorMessage.prototype.config = function(){
    olookApp.subscribe("wishlist:add:error_message", this.facade, {}, this);
  };

  return AddToWishlistErrorMessage;
  
})();
var AddToWishlistSuccessMessage = (function(){
  
  function AddToWishlistSuccessMessage(){};

  AddToWishlistSuccessMessage.prototype.facade = function(message) {
    $('#js-addToWishlistButton').fadeOut();
    $('#js-removeFromWishlistButton').fadeIn();

    if($('.js-empty-wishlist-box').size() == 1){
      $('.js-empty-wishlist-box').addClass('wishlistHasProduct').removeClass('wishlist').removeClass('js-empty-wishlist-box').addClass('js-full-wishlist-box');
      $('.js-sub-text').html("Você possui <span class='js-product-count'>1</span> produto(s)<br />na sua lista de favoritos.");  
    } else if($(".js-full-wishlist-box").size() == 1 && $(".js-product-count").size() == 1){
      $(".js-product-count").text(parseInt($(".js-product-count").text()) + 1); 
    }
    
  };

  AddToWishlistSuccessMessage.prototype.config = function(){
    olookApp.subscribe("wishlist:add:success_message", this.facade, {}, this);
  };

  return AddToWishlistSuccessMessage;

})();
var RemoveFromWishlist = (function(){
  function RemoveFromWishlist(){};

  RemoveFromWishlist.prototype.facade = function(productId) {
    var action_url = '/wished_products/' + productId;

    $.ajax({
      'type': 'DELETE',
      'url': action_url,
      'success': function(data) {
          olookApp.mediator.publish("wishlist:remove:success_message", productId);
      }}).fail(function(data){
          if (data.status == 401) {//non authorized
            window.location.href='/entrar';
          }
      });
  };

  RemoveFromWishlist.prototype.config = function() {
    olookApp.subscribe('wishlist:remove:click_button', this.facade, {}, this);
  };

  return RemoveFromWishlist;
})();
var RemoveFromWishlistSuccessMessage = (function(){
  function RemoveFromWishlistSuccessMessage(){};
  RemoveFromWishlistSuccessMessage.prototype.facade = function(productId) {
    // product-page
    $('#js-removeFromWishlistButton').fadeOut();
    $('#js-addToWishlistButton').fadeIn();

    // wishlist page
    $('.js-product-' + productId).fadeOut();
    $('.js-product-' + productId).remove();

    if ($('.product').size() == 0) {
      $('.noProductWished').show();
    }

    if($(".js-full-wishlist-box").size() == 1 && parseInt($(".js-product-count").text()) == 1){
      $('.js-full-wishlist-box').addClass('wishlist').removeClass('wishlistHasProduct').removeClass('js-full-wishlist-box').addClass('js-empty-wishlist-box');
      $('.js-sub-text').html("Você ainda não adicionou nenhum<br />produto a sua lista de favoritos.");
    }else if($(".js-full-wishlist-box").size() == 1 && parseInt($(".js-product-count").text()) > 1){
      $(".js-product-count").text(parseInt($(".js-product-count").text()) - 1);
    }
  };

  RemoveFromWishlistSuccessMessage.prototype.config = function(){
    olookApp.subscribe("wishlist:remove:success_message", this.facade, {}, this);
  };

  return RemoveFromWishlistSuccessMessage;
})();



window.onload = function() {
  initQuickView.productZoom();
  load_all_other_images();
}

$(document).ready(function(){
  load_first_image();
  accordion();
  delivery();
  guaranteedDelivery(); 
  loadWishlistModules(); 
});

load_first_image = function() {
  new ImageLoader().load("thumb-first");
}

load_all_other_images = function() {
  new ImageLoader().load("thumb");
}

var loadWishlistModules = function() {
  new AddToWishlist().config();
  new AddToWishlistSuccessMessage().config();
  new AddToWishlistErrorMessage().config();  
  new RemoveFromWishlist().config();
  new RemoveFromWishlistSuccessMessage().config();
}

$(function() {
  var stringDesc = $("div#infos div.description p.description").text();
  
  /** MODAL GUIA DE MEDIDAS **/
  $(".size_guide a").click(function(e){
    modal.show($("#modal_guide"));
    e.preventDefault();
    
  })

  $("div#product-details a.more").live("click", function() {
    el = $(this).parent();
    el.text(stringDesc);
    el.append("<a href='javascript:void(0);' class='less'>Esconder</a>");
  });

  $("div#gallery ul#thumbs li a").live("click", function() {
    rel = $(this).attr('rel');
    $("div#gallery div#full_pic ul li").hide();
    $("div#gallery div#full_pic ul li."+rel).show();
    $("ul#thumbs li a").find("img.selected").removeClass("selected");
    $(this).children().addClass("selected");
    return false;
  });

  
  $("div#product-details div.size ol li").live('click', function() {
    if($(this).hasClass("unavailable") == false) {
      lists = $(this).parents("ol").find("li");
      lists.find("input[type='radio']").attr('checked', false);
      lists.removeClass("selected");
      $(this).find("input[type='radio']").attr('checked', true);
      $(this).addClass('selected');
      inventory = $(this).find("input[type='hidden']").val();
      badge = $("div#gallery div#full_pic p.warn.quantity");
      remaining = $("div#product-details p.remaining");
      if(inventory < 2) {
        $(remaining).html("Resta apenas <strong><span>0</span> unidade</strong> para o seu tamanho");
      } else {
        $(remaining).html("Restam apenas <strong><span>0</span> unidades</strong> para o seu tamanho");
      }
      $(remaining).hide();
      $(badge).hide();
      if(inventory <= 3) {
        $(remaining).find("span").text(inventory);
        $(".js-remaining-badge").text(inventory);
        $(remaining).show();
        $(badge).show();
      }
      return false;
    }
  });

  $("#add_item").live('submit', function(event) {
    if(initQuickView.inQuickView) {
      $("#close_quick_view").trigger('click');
    }

    initBase.openDialog();
    $('body .dialog').show();
    $('body .dialog').css("left", ((viewWidth  - '930') / 2) + $('body').scrollLeft() );
    $('body .dialog').css("top", ((viewHeight  - '515') / 2) + $('body').scrollTop() );
    $('body .dialog #login_modal').fadeIn('slow');
    initBase.closeDialog();
  });

});

initQuickView = {
  inQuickView : false,

  productZoom : function() {
    $("div#gallery div#full_pic ul li a.image_zoom").each(function(){
      var _url = $(this).attr('href');
      if(/^\/\//.test(_url)){
        _url = "https:" + _url
      }
      $(this).zoom({url: _url})
    });
  },

  twitProduct : function() {
    $("ul.social li.twitter a").live("click", function(e) {
      var width  = 575,
          height = 400,
          left   = ($(window).width()  - width)  / 2,
          top    = ($(window).height() - height) / 2,
          url    = this.href,
          opts   = 'status=1' +
                   ',width='  + width  +
                   ',height=' + height +
                   ',top='    + top    +
                   ',left='   + left;

      window.open(url, 'twitter', opts);
      e.preventDefault();
    });
  },

  pinProduct : function() {
    $("ul.social li.pinterest a").live("click", function(e) {
      var width  = 710,
          height = 545,
          left   = ($(window).width()  - width)  / 2,
          top    = ($(window).height() - height) / 2,
          url    = this.href,
          opts   = 'status=1' +
                   ',width='  + width  +
                   ',height=' + height +
                   ',top='    + top    +
                   ',left='   + left;

      window.open(url, 'pinterest', opts);
      e.preventDefault();
    });
  },

  shareProductOnFacebook : function() {
    $("ul.social li.facebook a").live("click", function() {
      postProductToFacebookFeed();
      return false;
    })
  }
};

function accordion(){
  el = $("#product-particulars h3");
  el.on("click", function(e){
    e.stopPropagation();
    e.preventDefault();
    isOpen = $(this).hasClass( "open");
    if(!isOpen){
      $(this).siblings("h3").removeClass("open").siblings("div").slideUp();
      $(this).addClass("open").next().addClass("open").slideDown();
    } else {
      $(this).removeClass("open").siblings("div").slideUp();    
    }
  });  
}

function guaranteedDelivery(){
  $('.payment_type input').click(function(e){
    if($("#checkout_payment_method_billet").is(':checked')) {
      $('#billet_expiration').slideDown();
    } else {
      $('#billet_expiration').slideUp();
    }
  });
}

function findDeliveryTime(it, warranty_deliver){
    var cep = it.siblings('.ship-field').val();
    if(cep.length < 9){
      $(".shipping-msg").removeClass("ok").hide().delay(500).fadeIn().addClass("error").text("O CEP informado parece estranho. Que tal conferir?");
      return false;
    }else{
      var suf = '';
      if (warranty_deliver) {
        suf = '?warranty_deliver=1';
      }
      $.getJSON("/shippings/"+cep+suf, function(data){
        var klass = 'ok';
        if(data['class']){
          klass = data['class'];
        }
        it.parent().siblings(".shipping-msg").removeClass("error").hide().delay(500).fadeIn().addClass(klass).text(data.message);
      });
    }
  }
function delivery(){
  var sf = $("#ship-field, #cepDelivery");
  if(sf.setMask)
    sf.setMask({mask: '99999-999'});
  $("#shipping #search").click(function(){
    var it = $(this);
    if(it.data('warrantyDeliver')){
      findDeliveryTime(it, true);
    } else {
      findDeliveryTime(it);
    }
  });
}
;
