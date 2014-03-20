function changeCatalogBaseType(){
  var type = $('#header_type');
  var small_fieldset = $('fieldset#small_banner_catalog_header');
  var big_fieldset = $('fieldset#big_banner_catalog_header');
  var text_fieldset = $('fieldset#text_catalog_header');
  if(type.val() == 'SmallBannerCatalogHeader') {
    small_fieldset.show();
    big_fieldset.hide();
    text_fieldset.hide();
  } else if (type.val() == 'NoBanner'){
    small_fieldset.hide();
    big_fieldset.hide();
    text_fieldset.hide();
  } else if (type.val() == 'BigBannerCatalogHeader'){
    small_fieldset.hide();
    big_fieldset.show();
    text_fieldset.hide();
  } else if(type.val() == 'TextCatalogHeader'){
    small_fieldset.hide();
    big_fieldset.hide();
    text_fieldset.show();
  }
  type.change(function(){
    small_fieldset.hide();
    big_fieldset.hide();
    text_fieldset.hide();
    if($(this).val() == 'SmallBannerCatalogHeader') {
      small_fieldset.show();
    }else if ($(this).val() == 'BigBannerCatalogHeader'){
      big_fieldset.show();
    } else if($(this).val() == 'TextCatalogHeader'){
      text_fieldset.show();
    }
  });
};

$(function(){
  $(changeCatalogBaseType);
});
