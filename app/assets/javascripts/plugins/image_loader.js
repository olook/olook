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