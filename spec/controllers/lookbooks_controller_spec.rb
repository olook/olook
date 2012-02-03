require 'spec_helper'

describe LookbooksController do  
  describe "Lookboooks show page" do
    let!(:product)      { FactoryGirl.create(:basic_shoe) }
    let!(:lookbook)      { FactoryGirl.create(:basic_lookbook, 
                        :product_list => { "#{product.id}" => "1" }, 
                        :product_criteo => { "#{product.id}" => "1" } ) }
    
    context "Check if the correctly vars are being setting up" do

      before(:each) do
        get :show, :name => lookbook.name
      end

      it "Check if lookbook was found" do
        assigns(:lookbook).should eq(lookbook)
      end

      it "Check if products related with lookbook were found" do
        assigns(:products).should eq([product])
      end

      it "Check if products_id related with lookbook were found" do
        assigns(:products_id).should eq([product.id])
      end

      it "Check if all lookbooks were found" do
        assigns(:lookbooks).should eq([lookbook])
      end

    end

  end

end
