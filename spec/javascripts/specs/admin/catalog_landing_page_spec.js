describe("Show and Hide according CatalogLandingPage#type", function(){
  beforeEach(function(){
    loadFixtures('catalog_landing_page_form.html');
  });

  it("show #small_banner_catalog_header when type is CatalogHeader::SmallBannerCatalogHeader", function(){
    var type = $('#catalog_base_type');
    var small_fieldset = $('fieldset#small_banner_catalog_header');
    var big_fieldset = $('fieldset#big_banner_catalog_header');
    var text_fieldset = $('fieldset#text_catalog_header');
    changeCatalogBaseType();
    type.val('CatalogHeader::SmallBannerCatalogHeader').change();
    expect(small_fieldset).toBeVisible();
    expect(big_fieldset).toBeHidden();
    expect(text_fieldset).toBeHidden();
  });
});
