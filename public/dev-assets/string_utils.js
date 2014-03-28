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
