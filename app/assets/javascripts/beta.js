// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require ./modules/address/app
//= require ./modules/freight/controller
$(function(){
  new FreightController().config();
});
