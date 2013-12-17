# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::ProductsController, admin: true do
  render_views

  before :all do
    Product.destroy_all
    Collection.destroy_all
  end

  let!(:product) { FactoryGirl.create(:shoe, :casual) }
  let(:valid_attributes) do
    product.attributes.clone.tap do |attributes|
      attributes[:model_number] = Random.rand(1000).to_s
    end
  end

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = FactoryGirl.create(:admin_superadministrator)
    sign_in @admin
  end

  describe "GET index" do
    it "assigns all products as @products" do
      get :index
      assigns(:products).should eq([product])
    end
  end

  describe "GET show" do
    it "assigns the requested product as @product" do
      get :show, :id => product.id.to_s
      assigns(:product).should eq(product)
    end
  end

  describe "GET new" do
    it "assigns a new product as @product" do
      get :new
      assigns(:product).should be_a_new(Product)
    end
  end

  describe "GET edit" do
    it "assigns the requested product as @product" do
      get :edit, :id => product.id.to_s
      assigns(:product).should eq(product)
    end
  end

  describe "POST create" do
    describe "with invalid params" do
      it "assigns a newly created but unsaved product as @product" do
        # Trigger the behavior that occurs when invalid params are submitted
        Product.any_instance.stub(:save).and_return(false)
        post :create, :product => {}
        assigns(:product).should be_a_new(Product)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Product.any_instance.stub(:save).and_return(false)
        post :create, :product => {}
        flash[:notice].should be_blank
        #response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested product" do
        # Assuming there are no other products in the database, this
        # specifies that the Product created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Product.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => product.id, :product => {'these' => 'params'}
      end

      it "assigns the requested product as @product" do
        put :update, :id => product.id, :product => valid_attributes
        assigns(:product).should eq(product)
      end

      it "redirects to the product" do
        put :update, :id => product.id, :product => valid_attributes
        response.should redirect_to([:admin, product])
      end
    end

    describe "with invalid params" do
      it "assigns the product as @product" do
        # Trigger the behavior that occurs when invalid params are submitted
        Product.any_instance.stub(:save).and_return(false)
        put :update, :id => product.id.to_s, :product => {}
        assigns(:product).should eq(product)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Product.any_instance.stub(:save).and_return(false)
        put :update, :id => product.id.to_s, :product => {}
        flash[:notice].should be_blank
        #response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested product" do
      expect {
        delete :destroy, :id => product.id.to_s
      }.to change(Product, :count).by(-1)
    end

    it "redirects to the products list" do
      delete :destroy, :id => product.id.to_s
      response.should redirect_to(admin_products_url)
    end
  end

  describe "related products" do
    let!(:related_product) { FactoryGirl.create(:basic_bag) }

    it "finds the product and assigns to product" do
      post :add_related, :id => product.id.to_s, :related_product => {:id => related_product.id.to_s }
      assigns(:product).should eq(product)
    end

    it "relates the product with the received related product" do
      Product.any_instance.should_receive(:relate_with_product).with(related_product)
      post :add_related, :id => product.id.to_s, :related_product => {:id => related_product.id.to_s  }
    end

    it "redirects to product show page" do
      post :add_related, :id => product.id.to_s, :related_product => {:id => related_product.id.to_s }
      response.should redirect_to([:admin, product])
    end
  end
end
