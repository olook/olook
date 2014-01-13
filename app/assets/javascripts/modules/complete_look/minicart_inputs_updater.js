function MinicartInputsUpdater(){
  this.facade = function(variantNumbers, variantNumber, inputValues){
    for(i=0;i<variantNumbers.length;i++){
      $('#variant_numbers_[value=\"'+variantNumbers[i]+'\"]').remove();
      $('#variant_numbers[][value=\"'+variantNumbers[i]+'\"]').remove();  
    }

    if(variantNumber.length > 0){
      $('#minicart').append(inputValues);
    }
  }
}

/* 
 * assim que o documento for renderizado, devemos criar uma nova instancia do modulo e declarar o subscribe
 * usando o metodo de facade como callback
 */
$(function(){
  olookApp.mediator.subscribe("updateMinicartInputs", new MinicartInputsUpdater().facade);   
});