var showInfoCredits = function() {
  $("a.open_loyalty_lightbox").live('click', function(e) {
    _gaq.push(['_trackEvent', 'product_show', 'show_loyalty_info', '']);
    content = $("div.credits_description");
    modal.show(content);
    e.preventDefault();
  });
};
/**
  * Formatter. This object may be used by the whole applicaton
  */


var Formatter = Formatter || {
  /**
    * Converts number to currency (Real with ',' for decimal)
    *
    */
  toCurrency: function(value) {
    return "R$ " + value.toFixed(2).toString().replace('.',',');
  }
};
var CreditCard = {};

CreditCard = {
  validateNumber: function(str) {
    var luhnArr = [0, 2, 4, 6, 8, 1, 3, 5, 7, 9];
    var counter = 0;
    var incNum;
    var odd = false;
    var temp = String(str).replace(/[^\d]/g, "");
    if ( temp.length == 0)
      return false;
    for (var i = temp.length-1; i >= 0; --i) {
      incNum = parseInt(temp.charAt(i), 10);
      counter += (odd = !odd)? incNum : luhnArr[incNum];
    }
    return (counter%10 == 0);
  },

  installmentsNumberFor: function(value, reseller) {
    number = Math.floor((value / 30));
    if(reseller === "true"){
      number = Math.min(3, number);
    }else{
      number = Math.min(6, number);
    }
    return number == 0 ? 1 : number;
  }
};

(function($){
  $.fn.validateCreditCardNumber = function() {
    return this.each(function() {
      $(this).blur(function() {
      $("#credit_card_error").remove();
        if (CreditCard.validateNumber(this.value)) {
          $(".credit_card_number").removeClass("input_error");
        } else {
          parent_node = $("#checkout_payment_credit_card_number").parent().parent();
          parent_node.append('<span id="credit_card_error" class="span_error">O número do cartão parece estranho. Pode conferir?</span>');
          $(".credit_card_number").addClass("input_error");
        }
      });
    });
  };
})(jQuery);

$(function() {
  $("#checkout_payment_credit_card_number").validateCreditCardNumber();
});
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
if(!modal) var modal = {};

modal.show = function(content){
  console.log("showing!");
  var modalWindow = $("div#modal.promo-olook"),
  h = $(content).outerHeight(),
  w = $(content).outerWidth(),
  ml = -parseInt((w/2)),
  mt = -parseInt((h/2)),
  heightDoc = $(document).height(),
  _top = Math.max(0, (($(window).height() - h) / 2) + $(window).scrollTop()),
  _left=Math.max(0, (($(window).width() - w) / 2) + $(window).scrollLeft());

  $("#overlay-campaign").css({"background-color": "#000", 'height' : heightDoc}).fadeIn().bind("click", function(){
   _iframe = modalWindow.contents().find("iframe") || null;

    if (_iframe.length > 0){
      $(_iframe).remove();
    }

     $("#modal").hide();
     $(this).fadeOut();
  });

  modalWindow.html(content)
  .css({
     'height'      : h,
     'width'       : w,
     'top'         : _top,
     'left'        : _left
  })
 .append('<button type="button" class="close" role="button">close</button>')
 .delay(500).fadeIn().children().fadeIn();

 $("#modal button.close, #modal a.me").click(function(){
   _iframe = modalWindow.contents().find("iframe") || null;

   if (_iframe.length > 0){
     $(_iframe).remove();
   }

    $("#modal").hide();
    $("#overlay-campaign").fadeOut();
 })

}
;
/**** TO VALENTINES DAY ****/

function showAlert(){
  $("html, body").animate({ scrollTop: 0 }, "slow");
  $('#error-messages').css("height", "40px").slideDown('1000', function() {
    $('p.alert', this).text("Por favor, antes de pedir, selecione o tamanho do produto");
  }).delay(5000).slideUp();
}

function getSize(){
  if(window.location.href.indexOf('size') > 0){
    var size = window.location.href.slice(window.location.href.indexOf('size')).split('=');
    $("div.line.size ol li.size_"+size[1]).addClass("selected").find("input[type='radio']").prop('checked', true);
  }
}
/**** END TO VALENTINES DAY ****/
;
/**
 * jquery.meio.mask.js
 * @author: fabiomcosta
 * @version: 1.1.3
 *
 * Created by Fabio M. Costa on 2008-09-16. Please report any bug at http://www.meiocodigo.com
 *
 * Copyright (c) 2008 Fabio M. Costa http://www.meiocodigo.com
 *
 * The MIT License (http://www.opensource.org/licenses/mit-license.php)
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */


(function($){
		
	var isIphone = (window.orientation != undefined),
		// browsers like firefox2 and before and opera doenst have the onPaste event, but the paste feature can be done with the onInput event.
		pasteEvent = (($.browser.opera || ($.browser.mozilla && parseFloat($.browser.version.substr(0,3)) < 1.9 ))? 'input': 'paste');
		
	$.event.special.paste = {
		setup: function() {
	    	if(this.addEventListener)
	        	this.addEventListener(pasteEvent, pasteHandler, false);
   			else if (this.attachEvent)
				this.attachEvent(pasteEvent, pasteHandler);
		},

		teardown: function() {
			if(this.removeEventListener)
	        	this.removeEventListener(pasteEvent, pasteHandler, false);
   			else if (this.detachEvent)
				this.detachEvent(pasteEvent, pasteHandler);
		}
	};
	
	// the timeout is set because we can't get the value from the input without it
	function pasteHandler(e){
		var self = this;
		e = $.event.fix(e || window.e);
		e.type = 'paste';
		// Execute the right handlers by setting the event type to paste
		setTimeout(function(){ $.event.handle.call(self, e); }, 1);
	};

	$.extend({
		mask : {
			
			// the mask rules. You may add yours!
			// number rules will be overwritten
			rules : {
				'z': /[a-z]/,
				'Z': /[A-Z]/,
				'a': /[a-zA-Z]/,
				'*': /[0-9a-zA-Z]/,
				'@': /[0-9a-zA-ZçÇáàãâéèêíìóòôõúùü]/,
				'x': /[0-9a-fA-F]/
			},
			
			// these keys will be ignored by the mask.
			// all these numbers where obtained on the keydown event
			keyRepresentation : {
				8	: 'backspace',
				9	: 'tab',
				13	: 'enter',
				16	: 'shift',
				17	: 'control',
				18	: 'alt',
				27	: 'esc',
				33	: 'page up',
				34	: 'page down',
				35	: 'end',
				36	: 'home',
				37	: 'left',
				38	: 'up',
				39	: 'right',
				40	: 'down',
				45	: 'insert',
				46	: 'delete',
				116	: 'f5',
				123 : 'f12',
				224	: 'command'
			},
			
			iphoneKeyRepresentation : {
				10	: 'go',
				127	: 'delete'
			},
			
			signals : {
				'+' : '',
				'-' : '-'
			},
			
			// default settings for the plugin
			options : {
				attr: 'alt', // an attr to look for the mask name or the mask itself
				mask: null, // the mask to be used on the input
				type: 'fixed', // the mask of this mask
				maxLength: -1, // the maxLength of the mask
				defaultValue: '', // the default value for this input
				signal: false, // this should not be set, to use signal at masks put the signal you want ('-' or '+') at the default value of this mask.
							   // See the defined masks for a better understanding.
				
				textAlign: true, // use false to not use text-align on any mask (at least not by the plugin, you may apply it using css)
				selectCharsOnFocus: true, // select all chars from input on its focus
				autoTab: true, // auto focus the next form element when you type the mask completely
				setSize: false, // sets the input size based on the length of the mask (work with fixed and reverse masks only)
				fixedChars : '[(),.:/ -]', // fixed chars to be used on the masks. You may change it for your needs!
				
				onInvalid : function(){},
				onValid : function(){},
				onOverflow : function(){}
			},
			
			// masks. You may add yours!
			// Ex: $.fn.setMask.masks.msk = {mask: '999'}
			// and then if the 'attr' options value is 'alt', your input should look like:
			// <input type="text" name="some_name" id="some_name" alt="msk" />
			masks : {
				'phone'				: { mask : '(99) 9999-9999' },
				'phone-us'			: { mask : '(999) 999-9999' },
				'cpf'				: { mask : '999.999.999-99' }, // cadastro nacional de pessoa fisica
				'cnpj'				: { mask : '99.999.999/9999-99' },
				'date'				: { mask : '39/19/9999' }, //uk date
				'date-us'			: { mask : '19/39/9999' },
				'cep'				: { mask : '99999-999' },
				'time'				: { mask : '29:59' },
				'cc'				: { mask : '9999 9999 9999 9999' }, //credit card mask
				'integer'			: { mask : '999.999.999.999', type : 'reverse' },				
				'decimal'			: { mask : '99,999.999.999.999', type : 'reverse', defaultValue : '000' },
				'decimal-us'		: { mask : '99.999,999,999,999', type : 'reverse', defaultValue : '000' },
				'signed-decimal'	: { mask : '99,999.999.999.999', type : 'reverse', defaultValue : '+000' },
				'signed-decimal-us' : { mask : '99,999.999.999.999', type : 'reverse', defaultValue : '+000' }
			},
			
			init : function(){
				// if has not inited...
				if( !this.hasInit ){

					var self = this, i,
						keyRep = (isIphone)? this.iphoneKeyRepresentation: this.keyRepresentation;
						
					this.ignore = false;
			
					// constructs number rules
					for(i=0; i<=9; i++) this.rules[i] = new RegExp('[0-'+i+']');
				
					this.keyRep = keyRep;
					// ignore keys array creation for iphone or the normal ones
					this.ignoreKeys = [];
					$.each(keyRep,function(key){
						self.ignoreKeys.push( parseInt(key) );
					});
					
					this.hasInit = true;
				}
			},
			
			set: function(el,options){
				
				var maskObj = this,
					$el = $(el),
					mlStr = 'maxLength';
				
				options = options || {};
				this.init();
				
				return $el.each(function(){
					
					if(options.attr) maskObj.options.attr = options.attr;
					
					var $this = $(this),
						o = $.extend({}, maskObj.options),
						attrValue = $this.attr(o.attr),
						tmpMask = '';
						
					// then we look for the 'attr' option
					tmpMask = (typeof options == 'string')? options: (attrValue != '')? attrValue: null;
					if(tmpMask) o.mask = tmpMask;
					
					// then we see if it's a defined mask
					if(maskObj.masks[tmpMask]) o = $.extend(o, maskObj.masks[tmpMask]);
					
					// then it looks if the options is an object, if it is we will overwrite the actual options
					if(typeof options == 'object' && options.constructor != Array) o = $.extend(o, options);
					
					//then we look for some metadata on the input
					if($.metadata) o = $.extend(o, $this.metadata());
					
					if(o.mask != null){

						// prevents javascript automatic type convertion
						o.mask += '';
						
						if($this.data('mask')) maskObj.unset($this);
						
						var defaultValue = o.defaultValue,
							reverse = (o.type=='reverse'),
							fixedCharsRegG = new RegExp(o.fixedChars, 'g');
						
						if(o.maxLength == -1) o.maxLength = $this.attr(mlStr);
						
						o = $.extend({}, o,{
							fixedCharsReg: new RegExp(o.fixedChars),
							fixedCharsRegG: fixedCharsRegG,
							maskArray: o.mask.split(''),
							maskNonFixedCharsArray: o.mask.replace(fixedCharsRegG, '').split('')
						});
						
						//setSize option (this is not removed from the input (while removing the mask) since this would be kind of funky)
						if((o.type=='fixed' || reverse) && o.setSize && !$this.attr('size')) $this.attr('size', o.mask.length);
						
						//sets text-align right for reverse masks
						if(reverse && o.textAlign) $this.css('text-align', 'right');
						
						if(this.value!='' || defaultValue!=''){
							// apply mask to the current value of the input or to the default value
							var val = maskObj.string((this.value!='')? this.value: defaultValue, o);
							//setting defaultValue fixes the reset button from the form
							this.defaultValue = val;
							$this.val(val);
						}
						
						// compatibility patch for infinite mask, that is now repeat
						if(o.type=='infinite') o.type = 'repeat';
						
						$this.data('mask', o);
						
						// removes the maxLength attribute (it will be set again if you use the unset method)
						$this.removeAttr(mlStr);
						
						// setting the input events
						$this.bind('keydown.mask', {func:maskObj._onKeyDown, thisObj:maskObj}, maskObj._onMask)
							.bind('keypress.mask', {func:maskObj._onKeyPress, thisObj:maskObj}, maskObj._onMask)
							.bind('keyup.mask', {func:maskObj._onKeyUp, thisObj:maskObj}, maskObj._onMask)
							.bind('paste.mask', {func:maskObj._onPaste, thisObj:maskObj}, maskObj._onMask)
							.bind('focus.mask', maskObj._onFocus)
							.bind('blur.mask', maskObj._onBlur)
							.bind('change.mask', maskObj._onChange);
					}
				});
			},
			
			//unsets the mask from el
			unset : function(el){
				var $el = $(el);
				
				return $el.each(function(){
					var $this = $(this);
					if($this.data('mask')){
						var maxLength = $this.data('mask').maxLength;
						if(maxLength != -1) $this.attr('maxLength', maxLength);
						$this.unbind('.mask')
							.removeData('mask');
					}
				});
			},
			
			//masks a string
			string : function(str, options){
				this.init();
				var o={};
				if(typeof str != 'string') str = String(str);
				switch(typeof options){
					case 'string':
						// then we see if it's a defined mask	
						if(this.masks[options]) o = $.extend(o, this.masks[options]);
						else o.mask = options;
						break;
					case 'object':
						o = options;
				}
				if(!o.fixedChars) o.fixedChars = this.options.fixedChars;

				var fixedCharsReg = new RegExp(o.fixedChars),
					fixedCharsRegG = new RegExp(o.fixedChars, 'g');
					
				// insert signal if any
				if( (o.type=='reverse') && o.defaultValue ){
					if( typeof this.signals[o.defaultValue.charAt(0)] != 'undefined' ){
						var maybeASignal = str.charAt(0);
						o.signal = (typeof this.signals[maybeASignal] != 'undefined') ? this.signals[maybeASignal] : this.signals[o.defaultValue.charAt(0)];
						o.defaultValue = o.defaultValue.substring(1);
					}
				}
				
				return this.__maskArray(str.split(''),
							o.mask.replace(fixedCharsRegG, '').split(''),
							o.mask.split(''),
							o.type,
							o.maxLength,
							o.defaultValue,
							fixedCharsReg,
							o.signal);
			},
			
			// all the 3 events below are here just to fix the change event on reversed masks.
			// It isn't fired in cases that the keypress event returns false (needed).
			_onFocus: function(e){
				var $this = $(this), dataObj = $this.data('mask');
				dataObj.inputFocusValue = $this.val();
				dataObj.changed = false;
				if(dataObj.selectCharsOnFocus) $this.select();
			},
			
			_onBlur: function(e){
				var $this = $(this), dataObj = $this.data('mask');
				if(dataObj.inputFocusValue != $this.val() && !dataObj.changed)
					$this.trigger('change');
			},
			
			_onChange: function(e){
				$(this).data('mask').changed = true;
			},
			
			_onMask : function(e){
				var thisObj = e.data.thisObj,
					o = {};
				o._this = e.target;
				o.$this = $(o._this);
				// if the input is readonly it does nothing
				if(o.$this.attr('readonly')) return true;
				o.data = o.$this.data('mask');
				o[o.data.type] = true;
				o.value = o.$this.val();
				o.nKey = thisObj.__getKeyNumber(e);
				o.range = thisObj.__getRange(o._this);
				o.valueArray = o.value.split('');
				return e.data.func.call(thisObj, e, o);
			},
			
			_onKeyDown : function(e,o){
				// lets say keypress at desktop == keydown at iphone (theres no keypress at iphone)
				this.ignore = $.inArray(o.nKey, this.ignoreKeys) > -1 || e.ctrlKey || e.metaKey || e.altKey;
				if(this.ignore){
					var rep = this.keyRep[o.nKey];
					o.data.onValid.call(o._this, rep? rep: '', o.nKey);
				}
				return isIphone ? this._keyPress(e, o) : true;
			},
			
			_onKeyUp : function(e, o){
				//9=TAB_KEY 16=SHIFT_KEY
				//this is a little bug, when you go to an input with tab key
				//it would remove the range selected by default, and that's not a desired behavior
				if(o.nKey==9 || o.nKey==16) return true;
				
				if(o.data.type=='repeat'){
					this.__autoTab(o);
					return true;
				}

				return this._onPaste(e, o);
			},
			
			_onPaste : function(e,o){
				// changes the signal at the data obj from the input
				if(o.reverse) this.__changeSignal(e.type, o);
				
				var $thisVal = this.__maskArray(
					o.valueArray,
					o.data.maskNonFixedCharsArray,
					o.data.maskArray,
					o.data.type,
					o.data.maxLength,
					o.data.defaultValue,
					o.data.fixedCharsReg,
					o.data.signal
				);
				
				o.$this.val( $thisVal );
				// this makes the caret stay at first position when 
				// the user removes all values in an input and the plugin adds the default value to it (if it haves one).
				if( !o.reverse && o.data.defaultValue.length && (o.range.start==o.range.end) )
					this.__setRange(o._this, o.range.start, o.range.end);
					
				//fix so ie's and safari's caret won't go to the end of the input value.
				if( ($.browser.msie || $.browser.safari) && !o.reverse)
					this.__setRange(o._this,o.range.start,o.range.end);
				
				if(this.ignore) return true;
				
				this.__autoTab(o);
				return true;
			},
			
			_onKeyPress: function(e, o){
				
				if(this.ignore) return true;
				
				// changes the signal at the data obj from the input
				if(o.reverse) this.__changeSignal(e.type, o);
				
				var c = String.fromCharCode(o.nKey),
					rangeStart = o.range.start,
					rawValue = o.value,
					maskArray = o.data.maskArray;
				
				if(o.reverse){
					 	// the input value from the range start to the value start
					var valueStart = rawValue.substr(0, rangeStart),
						// the input value from the range end to the value end
						valueEnd = rawValue.substr(o.range.end, rawValue.length);
					
					rawValue = valueStart+c+valueEnd;
					//necessary, if not decremented you will be able to input just the mask.length-1 if signal!=''
					//ex: mask:99,999.999.999 you will be able to input 99,999.999.99
					if(o.data.signal && (rangeStart-o.data.signal.length > 0)) rangeStart-=o.data.signal.length;
				}

				var valueArray = rawValue.replace(o.data.fixedCharsRegG, '').split(''),
					// searches for fixed chars begining from the range start position, till it finds a non fixed
					extraPos = this.__extraPositionsTill(rangeStart, maskArray, o.data.fixedCharsReg);
				
				o.rsEp = rangeStart+extraPos;
				
				if(o.repeat) o.rsEp = 0;
				
				// if the rule for this character doesnt exist (value.length is bigger than mask.length)
				// added a verification for maxLength in the case of the repeat type mask
				if( !this.rules[maskArray[o.rsEp]] || (o.data.maxLength != -1 && valueArray.length >= o.data.maxLength && o.repeat)){
					// auto focus on the next input of the current form
					o.data.onOverflow.call(o._this, c, o.nKey);
					return false;
				}
				
				// if the new character is not obeying the law... :P
				else if( !this.rules[maskArray[o.rsEp]].test( c ) ){
					o.data.onInvalid.call(o._this, c, o.nKey);
					return false;
				}
				
				else o.data.onValid.call(o._this, c, o.nKey);
				
				var $thisVal = this.__maskArray(
					valueArray,
					o.data.maskNonFixedCharsArray,
					maskArray,
					o.data.type,
					o.data.maxLength,
					o.data.defaultValue,
					o.data.fixedCharsReg,
					o.data.signal,
					extraPos
				);
				
				o.$this.val( $thisVal );
				
				return (o.reverse)? this._keyPressReverse(e, o): (o.fixed)? this._keyPressFixed(e, o): true;
			},
			
			_keyPressFixed: function(e, o){

				if(o.range.start==o.range.end){
					// the 0 thing is cause theres a particular behavior i wasnt liking when you put a default
					// value on a fixed mask and you select the value from the input the range would go to the
					// end of the string when you enter a char. with this it will overwrite the first char wich is a better behavior.
					// opera fix, cant have range value bigger than value length, i think it loops thought the input value...
					if((o.rsEp==0 && o.value.length==0) || o.rsEp < o.value.length)
						this.__setRange(o._this, o.rsEp, o.rsEp+1);	
				}
				else
					this.__setRange(o._this, o.range.start, o.range.end);
					
				return true;
			},
			
			_keyPressReverse: function(e, o){
				//fix for ie
				//this bug was pointed by Pedro Martins
				//it fixes a strange behavior that ie was having after a char was inputted in a text input that
				//had its content selected by any range 
				if($.browser.msie && ((o.range.start==0 && o.range.end==0) || o.range.start != o.range.end ))
					this.__setRange(o._this, o.value.length);
				return false;
			},
			
			__autoTab: function(o){
				if(o.data.autoTab
					&& (
						(
							o.$this.val().length >= o.data.maskArray.length 
							&& !o.repeat 
						) || (
							o.data.maxLength != -1
							&& o.valueArray.length >= o.data.maxLength
							&& o.repeat
						)
					)
				){
					var nextEl = this.__getNextInput(o._this, o.data.autoTab);
					if(nextEl){
						o.$this.trigger('blur');
						nextEl.focus().select();
					}
				}
			},
			
			// changes the signal at the data obj from the input			
			__changeSignal : function(eventType,o){
				if(o.data.signal!==false){
					var inputChar = (eventType=='paste')? o.value.charAt(0): String.fromCharCode(o.nKey);
					if( this.signals && (typeof this.signals[inputChar] != 'undefined') ){
						o.data.signal = this.signals[inputChar];
					}
				}
			},
			
			__getKeyNumber : function(e){
				return (e.charCode||e.keyCode||e.which);
			},
			
			// this function is totaly specific to be used with this plugin, youll never need it
			// it gets the array representing an unmasked string and masks it depending on the type of the mask
			__maskArray : function(valueArray, maskNonFixedCharsArray, maskArray, type, maxlength, defaultValue, fixedCharsReg, signal, extraPos){
				if(type == 'reverse') valueArray.reverse();
				valueArray = this.__removeInvalidChars(valueArray, maskNonFixedCharsArray, type=='repeat'||type=='infinite');
				if(defaultValue) valueArray = this.__applyDefaultValue.call(valueArray, defaultValue);
				valueArray = this.__applyMask(valueArray, maskArray, extraPos, fixedCharsReg);
				switch(type){
					case 'reverse':
						valueArray.reverse();
						return (signal || '')+valueArray.join('').substring(valueArray.length-maskArray.length);
					case 'infinite': case 'repeat':
						var joinedValue = valueArray.join('');
						return (maxlength != -1 && valueArray.length >= maxlength)? joinedValue.substring(0, maxlength): joinedValue;
					default:
						return valueArray.join('').substring(0, maskArray.length);
				}
				return '';
			},
			
			// applyes the default value to the result string
			__applyDefaultValue : function(defaultValue){
				var defLen = defaultValue.length,thisLen = this.length,i;
				//removes the leading chars
				for(i=thisLen-1;i>=0;i--){
					if(this[i]==defaultValue.charAt(0)) this.pop();
					else break;
				}
				// apply the default value
				for(i=0;i<defLen;i++) if(!this[i])
					this[i] = defaultValue.charAt(i);
					
				return this;
			},
			
			// Removes values that doesnt match the mask from the valueArray
			// Returns the array without the invalid chars.
			__removeInvalidChars : function(valueArray, maskNonFixedCharsArray, repeatType){
				// removes invalid chars
				for(var i=0, y=0; i<valueArray.length; i++ ){
					if( maskNonFixedCharsArray[y] &&
						this.rules[maskNonFixedCharsArray[y]] &&
						!this.rules[maskNonFixedCharsArray[y]].test(valueArray[i]) ){
							valueArray.splice(i,1);
							if(!repeatType) y--;
							i--;
					}
					if(!repeatType) y++;
				}
				return valueArray;
			},
			
			// Apply the current input mask to the valueArray and returns it. 
			__applyMask : function(valueArray, maskArray, plus, fixedCharsReg){
				if( typeof plus == 'undefined' ) plus = 0;
				// apply the current mask to the array of chars
				for(var i=0; i<valueArray.length+plus; i++ ){
					if( maskArray[i] && fixedCharsReg.test(maskArray[i]) )
						valueArray.splice(i, 0, maskArray[i]);
				}
				return valueArray;
			},
			
			// searches for fixed chars begining from the range start position, till it finds a non fixed
			__extraPositionsTill : function(rangeStart, maskArray, fixedCharsReg){
				var extraPos = 0;
				while(fixedCharsReg.test(maskArray[rangeStart++])){
					extraPos++;
				}
				return extraPos;
			},
			
			__getNextInput: function(input, selector){
				var formEls = input.form.elements,
					initialInputIndex = $.inArray(input, formEls) + 1,
					$input = null,
					i;
				// look for next input on the form of the pased input
				for(i = initialInputIndex; i < formEls.length; i++){
					$input = $(formEls[i]);
					if(this.__isNextInput($input, selector))
						return $input;
				}
					
				var forms = document.forms,
					initialFormIndex = $.inArray(input.form, forms) + 1,
					y, tmpFormEls = null;
				// look for the next forms for the next input
				for(y = initialFormIndex; y < forms.length; y++){
					tmpFormEls = forms[y].elements;
					for(i = 0; i < tmpFormEls.length; i++){
						$input = $(tmpFormEls[i]);
						if(this.__isNextInput($input, selector))
							return $input;
					}
				}
				return null;
			},
			
			__isNextInput: function($formEl, selector){
				var formEl = $formEl.get(0);
				return formEl
					&& (formEl.offsetWidth > 0 || formEl.offsetHeight > 0)
					&& formEl.nodeName != 'FIELDSET'
					&& (selector === true || (typeof selector == 'string' && $formEl.is(selector)));
			},
			
			// http://www.bazon.net/mishoo/articles.epl?art_id=1292
			__setRange : function(input, start, end) {
				if(typeof end == 'undefined') end = start;
				if (input.setSelectionRange){
					input.setSelectionRange(start, end);
				}
				else{
					// assumed IE
					var range = input.createTextRange();
					range.collapse();
					range.moveStart('character', start);
					range.moveEnd('character', end - start);
					range.select();
				}
			},
			
			// adaptation from http://digitarald.de/project/autocompleter/
			__getRange : function(input){
				if (!$.browser.msie) return {start: input.selectionStart, end: input.selectionEnd};
				var pos = {start: 0, end: 0},
					range = document.selection.createRange();
				pos.start = 0 - range.duplicate().moveStart('character', -100000);
				pos.end = pos.start + range.text.length;
				return pos;
			},
			
			//deprecated
			unmaskedVal : function(el){
				return $(el).val().replace($.mask.fixedCharsRegG, '');
			}
			
		}
	});
	
	$.fn.extend({
		setMask : function(options){
			return $.mask.set(this, options);
		},
		unsetMask : function(){
			return $.mask.unset(this);
		},
		//deprecated
		unmaskedVal : function(){
			return $.mask.unmaskedVal(this[0]);
		}
	});
})(jQuery);


// Acho que podemos apagar esse arquivo (pelo menos na pagina de produto nao esta sendo usado - Rafael)
if(!image_loader) var image_loader = {};

image_loader.init = function(){
  image_loader.setMouseOverOnImages();
  image_loader.replaceImages();
  image_loader.spyOverChangeImage();
}

image_loader.replaceImages = function(imageKind){
  if(typeof imageKind == 'undefined') imageKind = 'showroom';
  $('img.async').each(function(){
    var image = $(this).data(imageKind);
    $(this).attr('src', image);
  });

}

image_loader.setMouseOverOnImages =  function() {
  $('img.async').on('mouseenter', function () {
    var backside_image = $(this).attr('data-backside');
    $(this).attr('src', backside_image);
    }).on('mouseleave', function () {
      var field_name = 'data-product';
      var showroom_image = $(this).attr(field_name);
      $(this).attr('src', showroom_image);
    });
}

image_loader.spyOverChangeImage = function(){
   $(".spy").on({
      mouseover: function() {
         var backside_image = $(this).parents(".hover_suggestive").next().find("img").attr('data-backside');
         $(this).parents(".hover_suggestive").next().find("img").attr('src', backside_image);
       },
       mouseout: function() {
         var field_name = 'data-product';
         var showroom_image = $(this).parents(".hover_suggestive").next().find("img").attr(field_name);
         $(this).parents(".hover_suggestive").next().find("img").attr('src', showroom_image);
       }
   });
}


image_loader.init();
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
var completeLook = function(){

  var addLookItemToCart = function(actionUrl, values) {
    $.post(actionUrl, values, function( data ) {

      var minicartUpdate = {
        variantNumber: values.variant_number,
        productPrice: data.product_price,
        productId: data.product_id
      };

      olookApp.publish('minicart:update:data', minicartUpdate);
    });
  }

  var bindEvents = function(){
    $('li.product form #variant_number').change(function(e){
      var element = $(this);
      var actionUrl = element.parent().attr('action');

      var values = {
        'product_id': element.data('product-id'),
        'variant_number': element.val()
      }

      addLookItemToCart(actionUrl, values);
    });
  }

  return {
    bindEvents: bindEvents
  }

}();

$(function() {
  completeLook.bindEvents();
})
;
var MinicartBoxDisplayUpdater = (function(){
  function MinicartBoxDisplayUpdater(){};

  var showEmptyCartBox = function(){
    $('.cart_related').removeClass('product_added');
    $('.minicart_price').html("");
    $('.empty_minicart').fadeIn("fast");
  };

  var disableSubmitButton = function(){
    $(".js-addToCartButton").attr("disabled", "disabled").addClass("disabled");
  };

  var enableSubmitButton = function(){
    $(".js-addToCartButton").removeAttr("disabled").removeClass("disabled");
  };

  var isCartEmpty = function(){
    return ($( ".js-minicartItem").length == 0);
  };

  MinicartBoxDisplayUpdater.prototype.facade = function(params){
    if(isCartEmpty()) {
      showEmptyCartBox();
      disableSubmitButton();
    } else {
      enableSubmitButton();
    }
  };

  MinicartBoxDisplayUpdater.prototype.config = function() {
    olookApp.subscribe("minicart:update:box_display", this.facade, {}, this);
  };

  return MinicartBoxDisplayUpdater;
})();
var MinicartDataUpdater = (function(){
  function MinicartDataUpdater() {};

  var getProductName = function(productId) {
    return $('.js-look-product[data-id='+productId+']').data('name');
  }

  var writePrice = function(){
    var installments = CreditCard.installmentsNumberFor($("#total_price").val());
    if ($(".js-look-product").length == ($(".js-minicartItem").length) && (parseFloat($("#total_price").val()) > parseFloat($("#total_look_promotion_price").val()))){
      $(".minicart_price").html("De<span class='original_price'>" + installments + "x de " + Formatter.toCurrency( $("#total_price_without_discount").val() / installments ) + "</span>Por <span class='discounted_price'>"+$(".total_with_discount").html() + " sem juros</span>");

    } else if(($(".js-minicartItem").length) > 0){
      $(".minicart_price").html("Por<span class='first_price'>" + installments + "x de " + Formatter.toCurrency( $("#total_price").val() / installments ) + " sem juros </span>");
    }
  };

  var productNameInMinicart = function(productId){
    return($( ".js-minicartItem[data-id='"+ productId +"']" ));
  };

  var addItem = function(productId, productPrice){
    var productName = getProductName(productId);
    if(isCartEmpty()){
      $("#total_price").val(parseFloat(productPrice));
    } else {
      $("#total_price").val( parseFloat($("#total_price").val()) + parseFloat(productPrice));
    }
    $('.js-look-products').append("<li class='js-minicartItem' data-id='"+productId+"'>"+ productName +"</li>");
  };

  var removeItem = function(productId, productPrice){
    productNameInMinicart(productId).remove();
    if(isCartEmpty()){
      $("#total_price").val('');
    } else {
      $("#total_price").val( parseFloat($("#total_price").val()) - parseFloat(productPrice));
    }
  };

  var isAddition = function(productId, variantNumber){
    return (productNameInMinicart(productId).length == 0 && variantNumber.length > 0);
  };

  var isRemoval = function(productId, variantNumber){
    return (productNameInMinicart(productId).length > 0 && variantNumber.length == 0);
  };

  var isCartEmpty = function(){
    return ($( ".js-minicartItem").length == 0);
  };

  var applyDiscount = function(productPrice){};

  MinicartDataUpdater.prototype.facade = function(params){
    olookApp.publish('minicart:update:fadeout', params);
    olookApp.publish('minicart:update:input', params);
    setTimeout(function(){
      if (isAddition(params['productId'], params['variantNumber'])){
        addItem(params['productId'], params['productPrice']);
      } else if (isRemoval(params['productId'], params['variantNumber'])){
        removeItem(params['productId'], params['productPrice']);
      }
      writePrice();
      olookApp.publish('minicart:update:box_display', params);
      olookApp.publish('minicart:update:fadein');
    }, 300);
  };

  MinicartDataUpdater.prototype.config = function() {
    olookApp.subscribe('minicart:update:data', this.facade, {}, this);
  };

  return MinicartDataUpdater;
})();
var MinicartFadeInManager = (function(){
  function MinicartFadeInManager(){};

  var hasToFadeIn = function(){
    return ($('.cart_related').css("display") == "none");
  };

  var fadeIn = function(){
    $('.cart_related').fadeIn("fast");
  };

  MinicartFadeInManager.prototype.facade = function(params) {
    if(hasToFadeIn()) {
      fadeIn();
    }
  };

  MinicartFadeInManager.prototype.config = function() {
    olookApp.subscribe('minicart:update:fadein', this.facade, {}, this);
  }

  return MinicartFadeInManager;
})();

var MinicartFadeOutManager = (function(){
  function MinicartFadeOutManager() {};

  var hasToFadeOut = function(variantNumber){
    return $('.js-minicartItem').size() == 0 && !StringUtils.isEmpty(variantNumber);
  };

  var fadeOut = function(){
    $("#total_price").val('0.0');

    $('.cart_related').fadeOut("fast",function(){
      $('.cart_related').addClass('product_added');
      $('.empty_minicart').hide();
    });
  };

  MinicartFadeOutManager.prototype.facade = function(params){
    if(hasToFadeOut(params['variantNumber'])){
      fadeOut();
    }
  }

  MinicartFadeOutManager.prototype.config = function(){
    olookApp.subscribe('minicart:update:fadeout', this.facade, {}, this);
  }

  return MinicartFadeOutManager;
})();
var MinicartInputsUpdater = (function(){
  function MinicartInputsUpdater() {};

  var appendHiddenFieldToMiniCartForm = function(productId, variantNumber) {
    if (!StringUtils.isEmpty(variantNumber)) {
      $('<input type="hidden">').attr({
          'id': 'variant_numbers_',
          'name': 'variant_numbers[]',
          'value': variantNumber,
          'class': 'js-' + productId
      }).appendTo('#minicart');
    }
  }

  MinicartInputsUpdater.prototype.facade = function(params){
    $('.js-' + params['productId']).remove();
    appendHiddenFieldToMiniCartForm(params['productId'], params['variantNumber']);
  }

  /*
   * assim que o documento for renderizado, devemos criar uma nova instancia do modulo
   * e declarar o subscribe usando o metodo de facade como callback
   */
  MinicartInputsUpdater.prototype.config = function() {
    olookApp.subscribe("minicart:update:input", this.facade, {}, this);
  }

  return MinicartInputsUpdater;
})();












initProduct = {
  gotoRelatedProduct :function() {
    $('a#goRelatedProduct').live('click', function(e) {
      $("html, body").animate({
        scrollTop: 900
      }, 'fast');
      e.preventDefault();
    });
  },
  checkRelatedProducts : function() {
    return $("div#related ul.carousel").size() > 0 ? true : false;
  },
  showAlert : function(){
    $('p.alert_size').show().html("Qual é o seu tamanho mesmo?").delay(3000).fadeOut();
  },
  // for reasons unknown, this carousel is awkwardly inverted. I had to re-invert the names in order for it to work properly :P
  showCarousel : function() {
    if(initProduct.checkRelatedProducts() == true) {
      $("div#related ul.carousel").carouFredSel({
        auto: false,
        width: 860,
        items: 3,
        next : {
          button : ".carousel-prev",
          items : 3
        },
        prev : {
          button : ".carousel-next",
          items : 3
        }
      });
    }
  },
  plusQuantity: function() {
    initProduct.changeQuantity(1);
  },
  minusQuantity: function(){
    initProduct.changeQuantity(-1);
  },
  changeQuantity: function(by) {
    var maxVal = initProduct.selectedVariantMaxVal(),
      newVal = parseInt($("#variant_quantity").val()) + by;
    if(maxVal && newVal <= maxVal && newVal >= 1 ){
      $("#variant_quantity").val(newVal);
    }
  },
  selectedVariantMaxVal: function(){
    var variant = $('[name="variant[id]"]:checked');
    if (variant.length == 0) {
      initProduct.showAlert();
      return false;
    }
    var inventory = $('[name=inventory_' + variant.val() + ']');
    return inventory.val();
  },
  loadAddToCartForm : function() {
    if($('#compartilhar_email').length == 1) {
      var content = $('#compartilhar_email');
      $("ul.social-list li.email").on("click", function(e){
        e.preventDefault();
        e.stopPropagation();
        modal.show(content);
      });
    }
    $("#compartilhar_email form").submit(function(){
      $("input#send").addClass("opacidade").delay(300).attr('disabled', true);
    })

    $("a.open_loyalty_lightbox").show();

    $("form#product_add_to_cart").submit(function() {
      return !!(initProduct.selectedVariantMaxVal());
    });

    $("#add_product").click(function(e){
      e.preventDefault;
    });

    $(".plus").off('click').on('click', initProduct.plusQuantity);

    $(".minus").off('click').on('click', initProduct.minusQuantity);

    $("#variant_quantity").change(function(){
      var it = $(this);
      if (it.val() <= 0) {
        it.val(1);
      } else {
        var variant = $('[name="variant[id]"]:checked');
        var inventory = $('#inventory_' + variant.val());
        if(initProduct.selectedVariantMaxVal() && it.val() > inventory.val()) {
          it.val(inventory.val());
        }
      }
    });

    $('.size li').click(function(){
      $('#variant_quantity').val(1);
    });
  },
  loadAll : function() {
    initProduct.showCarousel();
    initProduct.gotoRelatedProduct();
    initProduct.loadUnloadTriggers();
    showInfoCredits();

    $("#product div.box_carousel a.open_carousel").live("click", function () {
      word = $(this).find("span");
      carousel = $(this).parent().find("div#carousel");
      if($(this).hasClass("open") == true) {
        $(carousel).animate({
          height: '0px'
        }, 'fast');
        $(this).removeClass("open");
        $(word).text("Abrir");
      } else{
        $(carousel).animate({
          height: '315px'
        }, 'fast');
        $(this).addClass("open");
        $(word).text("Fechar");
        _gaq.push(['_trackEvent', 'product_show','open_showroom' ]);

      }
    });

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
    initProduct.loadAddToCartForm();
  },

  loadUnloadTriggers : function() {
    $(window).on("beforeunload", function () {
      initProduct.unloadSelects();
    });
  },

  unloadSelects : function() {
    for(i = 0; i < $("li #variant_number").length; i++){
      $("li #variant_number")[i].selectedIndex = 0;
    }
  }
}

initProduct.loadAddToCartForm();

var bindWishlistEvents = function(){
  $('#js-addToWishlistButton').click(function(){
    olookApp.mediator.publish('wishlist:add:click_button');
  });

  $('#js-removeFromWishlistButton').click(function(){
    var productId = $(this).data('product-id');
    olookApp.mediator.publish('wishlist:remove:click_button', productId);
  });
};

var loadCompleteLookModules = function(){
  new MinicartFadeOutManager().config();
  new MinicartDataUpdater().config();
  new MinicartBoxDisplayUpdater().config();
  new MinicartFadeInManager().config();
  new MinicartInputsUpdater().config();
};

$(function(){
  loadCompleteLookModules();

  initProduct.loadAll();
  olook.spy('.spy');

  bindWishlistEvents();
});
