describe("Show and Hide according CatalogLandingPage#type", function(){
  beforeEach(function(){
    loadFixtures('catalog_landing_page_form.html');
  });

  it("show #small_banner_catalog_header when type is CatalogHeader::SmallBannerCatalogHeader", function(){
    var type = $('#catalog_base_type');
    changeCatalogBaseType();
    type.val('CatalogHeader::SmallBannerCatalogHeader').change();
    var small_fieldset = $('fieldset#small_banner_catalog_header');
    var big_fieldset = $('fieldset#big_banner_catalog_header');
    var text_fieldset = $('fieldset#text_catalog_header');
    expect(small_fieldset).toBeVisible();
    expect(big_fieldset).toBeHidden();
    expect(text_fieldset).toBeHidden();
  });

  it("show #big_banner_catalog_header when type is CatalogHeader::BigBannerCatalogHeader", function(){
    var type = $('#catalog_base_type');
    changeCatalogBaseType();
    type.val('CatalogHeader::BigBannerCatalogHeader').change();
    var small_fieldset = $('fieldset#small_banner_catalog_header');
    var big_fieldset = $('fieldset#big_banner_catalog_header');
    var text_fieldset = $('fieldset#text_catalog_header');
    expect(small_fieldset).toBeHidden();
    expect(big_fieldset).toBeVisible();
    expect(text_fieldset).toBeHidden();
  });

  it("show #text_catalog_header when type is CatalogHeader::TextCatalogHeader", function(){
    var type = $('#catalog_base_type');
    changeCatalogBaseType();
    type.val('CatalogHeader::TextCatalogHeader').change();
    var small_fieldset = $('fieldset#small_banner_catalog_header');
    var big_fieldset = $('fieldset#big_banner_catalog_header');
    var text_fieldset = $('fieldset#text_catalog_header');
    expect(text_fieldset).toBeVisible();
    expect(small_fieldset).toBeHidden();
    expect(big_fieldset).toBeHidden();
  });
});
