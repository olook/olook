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
var showInfoCredits = function() {
  $("a.open_loyalty_lightbox").live('click', function(e) {
    _gaq.push(['_trackEvent', 'product_show', 'show_loyalty_info', '']);
    content = $("div.credits_description");
    modal.show(content);
    e.preventDefault();
  });
};
if(!olook) var olook = {};
olook.spy = function(selector){
  $(selector).click(function(e){
    e.preventDefault();
    var url = $(this).data('url');
    if(_gaq){
      var source = url.match(/from=(\w+)/);
      if(source){
        source = source[1];
      } else {
        source = 'Product';
      }
      _gaq.push(['_trackEvent', source, 'clickOnSpyProduct', url.replace(/\D/g, '')]);
    }
    $.ajax({
      url: url,
      cache: 'true',
      dataType: 'html',
      beforeSend: function() {
        var width = $(document).width(), height = $(document).height();
        $('#overlay-campaign').width(width).height(height).fadeIn();
        $('#ajax-loader').fadeIn();
      },
      success: function(dataHtml) {
        $('#ajax-loader').hide();

        initQuickView.inQuickView = true;

        if($("div#quick_view").size() == 0) {
          $("body").prepend("<div id='quick_view'></div>");
        }

        var width = $(document).width(), height = $(document).height();
        $('#overlay-campaign').width(width).height(height).fadeIn();

        var script = $(dataHtml).find('script:first').attr('src');

        $('#quick_view')
        .html(dataHtml)
        .css("top", $(window).scrollTop()  + 35)
        .fadeIn(100);

        $('#quick_view ol.colors li a').attr('data-remote', true);
        $("ul.social li.email").hide();


        $('#close_quick_view, #overlay-campaign').on("click", function() {
          $('#quick_view, #overlay-campaign').fadeOut(300);
        });
        if(typeof initProduct !== 'undefined') {
          initProduct.loadAddToCartForm();
        } else {
          $.getScript(script);
          $.getScript(script);
        }

        accordion();
        delivery();
        guaranteedDelivery();

        load_first_image();
        load_all_other_images();

        if (typeof initSuggestion != 'undefined') {
          initSuggestion.checkIfProductIsAlreadySelected();
        }
        initQuickView.productZoom();

        try{
          FB.XFBML.parse();
        }catch(ex){}
      },
      error: function() {
        window.location = url;
      }
    });
  }).mouseover(function() {
    var img = $(this).parent(".product").find("img");
    img.attr('src', img.data('backside-picture'));
  }).mouseout(function() {
    var img = $(this).parent(".product").find("img");
    img.attr('src', img.data('product'));
  });
};
if(!olook) var olook = {};
olook.checkFreebie = function() {
  $('input[name="i_want_freebie"]').unbind('change').change(function(){
    var it = $(this);
    var val = it.is(':checked') ? '1' : '0';
    $.ajax({
      url: it.data('url'),
      data: { i_want_freebie: val }
    });
  });
};

olook.showSmellPackageModal = function (){
   var content = $(".modal_smell:first");
   $("a.seeTheSmell").unbind('click').bind("click", function(e){
      olook.newModal(content, 340, 530);
      e.preventDefault();
      e.stopPropagation();
   });
};

olook.attachFreebieActions = function () {
  olook.showSmellPackageModal();
  olook.checkFreebie();
}


$(function(){
  olook.attachFreebieActions();
});
function FloatTotalScrollManager() {
  this.floated = document.getElementById('float_total');
  this.element = document.getElementById('close_cart');
};

FloatTotalScrollManager.prototype = {
  updateProperties: function() {
    if(this.isInsane()) return;
    this.elementHeight = this.element.offsetHeight;
    this.elementBounding = this.element.getBoundingClientRect();
  },

  config: function () {
    return olookApp.mediator.subscribe('window:onscroll', this.facade, {}, this);
  },

  fade: function(percentage) {
    if(this.isInsane()) return false;
    if(percentage > 1) {
      this.floated.style.display = 'none';
    } else {
      this.floated.style.display = 'block';
      this.floated.style.opacity = 1 - percentage;
    }
    return true;
  },

  isInsane: function() {
    if(typeof this.floated === 'undefined') return true;
    if(typeof this.element === 'undefined') return true;
    return false;
  },

  facade: function() {
    if(this.isInsane()) return;
    this.updateProperties();
    var windowHeight = window.innerHeight;
    var full = this.elementBounding.height - 30,
    actual = (windowHeight - this.elementBounding.top - 30)/full;
    this.fade(actual);
  }
};






function CartUpdater() {
  this.developer = 'Nelson Haraguchi';
};

CartUpdater.prototype = {
  changeView: function(data) {
    if(data.total) {
      $("#total_value").html(data.total);
      $("#float_total_value").html(data.total);
    }
    if (data.totalItens) {
      //update items quantity on cart summary header
      $("#cart_items").text(data.totalItens);

      //update items total on cart title
      $(".js-total-itens").html(data.totalItens);
    }
    if(typeof data.usingCoupon !== 'undefined') {
      if(data.usingCoupon) {
        $("#coupon_discount").html(data.couponCode);
        $('#js-coupon-discount-value').text(data.couponDiscountValue);
        $("#coupon_info").show();
        $("#coupon").hide();
      } else {
        $("#coupon_discount").html("");
        $('#js-coupon-discount-value').text('');
        $("#coupon_info").hide();
        $("#coupon").show();
      }
    }
    if(data.subtotal) {
      $('#subtotal_parcial').html(data.subtotal);
    }
  },
  config: function() {
    olookApp.mediator.subscribe('cart:update', this.changeView, {}, this);
  }
};

$(function() {
  new FloatTotalScrollManager().config();
  new CartUpdater().config();
  showInfoCredits();
  olook.spy('.cart_item[data-url]');
  if ($('#cart_gift_wrap').is(':checked')){
    $('#subtotal_parcial').after("<div id='embrulho_presente'></div>");
    var span_gift_target = $('#embrulho_presente');
    span_gift_target.html($("#gift_value").text().trim());
  }else{
    $('#embrulho_presente').remove();
  }
  if ($('#cart_use_credits').is(':checked') && $(".cupom").filter(":visible").length > 0){
    $('#subtotal_parcial').after("<div id='credito_fidelidade'></div>");
    var span_target = $('#credito_fidelidade');
    span_target.html("-"+$("#total_user_credits").text().trim());
  }else{
    $('#credito_fidelidade').remove();
  }

  $("form#coupon input").focus(function() {
    _gaq.push(['_trackEvent', 'Checkout', 'FillCupom', '', , true]);
  });


  $("#facebook_share").click(function(element) {
    postCartToFacebookFeed(element)
  })

  $("form#gift_message").bind("ajax:success", function(evt, xhr, settings) {
        document.location = $("a.continue").attr("href");
    });

    $(".continue").click(function() {
    $("form#gift_message").submit();
  });

  $('#cart_use_credits').change(function() {
    $('#use_credit_form').submit();
  });

  $( "#cart_gift_wrap" ).change(function() {
    $( "#gift_wrap" ).submit();
  });

  $("#credits_credits_last_order").change(function() {
    $("#credits_last_order").submit();
  });

  if($("div#carousel").size() > 0) {
    $("div#carousel ul.products_list").carouFredSel({
      auto: false,
      width: 760,
      items: {
        visible: 4
        },
      prev : {
        button : ".product-prev",
        items : 4
      },
      next : {
        button : ".product-next",
        items : 4
      }
    });
  }

  if($("div#carousel_lookbooks").size() > 0) {
    $("div#carousel_lookbooks ul").carouFredSel({
      auto: false,
      width: 970,
      items: 3,
      prev : {
        button : ".prev-lookbook",
        items : 1
      },
      next : {
        button : ".next-lookbook",
        items : 1
      },
      pagination: {
        container : "div#carousel_lookbooks .pagination",
        items : 1
      }
    });
  }

  showGiftPackageModal();
  showCreditPackageModal();
  olook.showSmellPackageModal();
});

function showGiftPackageModal(){
   var content = $(".modal_gift");
   $("a.txt-conheca").bind("click", function(e){
      olook.newModal(content, 504, 610, '#fff');
      e.preventDefault();
      e.stopPropagation();
   });
}

function changeCartItemQty(cart_item_id) {
  $('form#change_amount_' + cart_item_id).submit();
}

function postCartToFacebookFeed(element) {
  var obj = {
      picture: 'cdn.olook.com.br/assets/socialmedia/facebook/icon-app/app-2012-09-19.jpg',
      method: 'feed',
      caption: 'www.olook.com.br',
      link: 'http://www.olook.com.br',
      description: 'Comprei no site da olook e amei! Já conhece? Roupas, sapatos, bolsas e acessórios incríveis. Troca e devolução grátis em até 30 dias. Conheça!'
  }

  FB.ui(obj, function(response) {
    if (response && response.post_id) {
        var cart = $(element).data("cart-id")
      $.ajax({
        url: $(element).attr('href'),
        type: "PUT",
        data: { cart: { facebook_share_discount: true }  },
        dataType: "script"
        });
      _gaq.push(['_trackEvent', 'Checkout', 'FacebookShare', '', , true]);
      $("#facebook-share").hide();
      $(".msg").show();
      }
    }
  );
}
;
