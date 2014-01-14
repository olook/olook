function FloatTotalScrollManager() {
  this.floated = document.getElementById('float_total');
  this.element = document.getElementById('close_cart');
}

FloatTotalScrollManager.prototype.updateProperties = function() {
  if(this.isInsane()) return;
  this.elementHeight = this.element.offsetHeight;
  this.elementBounding = this.element.getBoundingClientRect();
}

FloatTotalScrollManager.prototype.config = function () {
  olookApp.mediator.subscribe('window.onscroll', new FloatTotalScrollManager());
}

FloatTotalScrollManager.prototype.fade = function(percentage) {
  if(this.isInsane()) return;
  if(percentage > 1) {
    this.floated.style.display = 'none';
  } else {
    this.floated.style.display = 'block';
    this.floated.style.opacity = 1 - percentage;
  }
}

FloatTotalScrollManager.prototype.isInsane = function() {
  if(typeof this.floated === 'undefined') return false;
  if(typeof this.element === 'undefined') return false;
  return true;
}

FloatTotalScrollManager.prototype.apply = function() {
  if(this.isInsane()) return;
  this.updateProperties();
  var windowHeight = window.innerHeight;
  var full = this.elementBounding.height - 30,
  actual = (windowHeight - this.elementBounding.top - 30)/full;
  this.fade(actual);
}

new FloatTotalScrollManager().config();
