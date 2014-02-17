// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){
  $('.add_fields').click(function(e){

    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');

    $('table.entries tr:last').after($(this).data('fields').replace(regexp, time));

    e.preventDefault();
  })  
});
