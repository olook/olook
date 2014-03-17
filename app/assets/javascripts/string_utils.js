StringUtils = {
  isEmpty: function(str){
    return !(str && str!=''); 
  }
};

String.prototype.isEmpty = StringUtils.isEmpty;
