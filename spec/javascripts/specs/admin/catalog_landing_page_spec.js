describe("Show and Hide according CatalogLandingPage#type", function(){
  beforeEach(function(){
    loadFixtures('catalog_landing_page_form.html');
    type = $('#catalog_base_type');

    small_fieldset = $('fieldset#small_banner_catalog_header');
    big_fieldset = $('fieldset#big_banner_catalog_header');
    text_fieldset = $('fieldset#text_catalog_header');    
    
    changeCatalogBaseType();
  });

  it("should attach a function to type's change event ", function() {
    expect(type).toHandle('change');
  });

  it("show #small_banner_catalog_header when type is CatalogHeader::SmallBannerCatalogHeader", function(){
    type.val('CatalogHeader::SmallBannerCatalogHeader').change();
    expect(small_fieldset).toBeVisible();
    expect(big_fieldset).toBeHidden();
    expect(text_fieldset).toBeHidden();
  });

  it("show #big_banner_catalog_header when type is CatalogHeader::BigBannerCatalogHeader", function(){
    type.val('CatalogHeader::BigBannerCatalogHeader').change();
    expect(small_fieldset).toBeHidden();
    expect(big_fieldset).toBeVisible();
    expect(text_fieldset).toBeHidden();
  });

  it("show #text_catalog_header when type is CatalogHeader::TextCatalogHeader", function(){
    type.val('CatalogHeader::TextCatalogHeader').change();
    expect(text_fieldset).toBeVisible();
    expect(small_fieldset).toBeHidden();
    expect(big_fieldset).toBeHidden();
  });
});
