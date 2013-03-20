// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {

    $("#search_product").autocomplete({
        source: "/search/product_suggestions"
    });

});
