function changeCatalogBaseType(){
  var type = $('#catalog_base_type');
  var small_fieldset = $('fieldset#small_banner_catalog_header');
  var big_fieldset = $('fieldset#big_banner_catalog_header');
  var text_fieldset = $('fieldset#text_catalog_header');
  if(type.val() == 'CatalogHeader::SmallBannerCatalogHeader') {
    small_fieldset.show();
  }else if (type.val() == 'CatalogHeader::BigBannerCatalogHeader'){
    big_fieldset.show();
  } else if(type.val() == 'CatalogHeader::TextCatalogHeader'){
    text_fieldset.show();
  }
  type.change(function(){
    small_fieldset.hide();
    big_fieldset.hide();
    text_fieldset.hide();
    if($(this).val() == 'CatalogHeader::SmallBannerCatalogHeader') {
      small_fieldset.show();
    }else if ($(this).val() == 'CatalogHeader::BigBannerCatalogHeader'){
      big_fieldset.show();
    } else if($(this).val() == 'CatalogHeader::TextCatalogHeader'){
      text_fieldset.show();
    }
  });
};

$(function(){
  $(changeCatalogBaseType);
});
