require 'spec_helper'

describe Admin::LookbookImageMapsController do
  let!(:product)      { FactoryGirl.create(:basic_shoe) }
  let!(:lookbook)      { FactoryGirl.create(:basic_lookbook,
                        :product_list => { "#{product.id}" => "1" },
                        :product_criteo => { "#{product.id}" => "1" } ) }

  pending
end
