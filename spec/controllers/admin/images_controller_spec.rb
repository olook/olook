require 'spec_helper'

describe Admin::ImagesController do
  render_views
  let(:lookbook) { FactoryGirl.create(:basic_lookbook) }
  let!(:image) { FactoryGirl.create(:image, :lookbook => lookbook) }
  let!(:valid_attributes) { image.attributes }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = FactoryGirl.create(:admin)
    sign_in @admin
  end

  describe "GET show" do
    it "assigns the requested image as @image" do
      get :show, :id => image.id.to_s, :lookbook_id => lookbook.id
      assigns(:image).should eq(image)
    end
  end

  describe "GET new" do
    it "assigns a new image as @image" do
      get :new, :lookbook_id => lookbook.id
      assigns(:image).should be_a_new(Image)
    end
  end

  describe "GET edit" do
    it "assigns the requested image as @image" do
      get :edit, :id => image.id.to_s, :lookbook_id => lookbook.id
      assigns(:image).should eq(image)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Image" do
        expect {
          post :create, :image => valid_attributes, :lookbook_id => lookbook.id
        }.to change(Image, :count).by(1)
      end

      it "assigns a newly created image as @image" do
        post :create, :image => valid_attributes, :lookbook_id => lookbook.id
        assigns(:image).should be_a(Image)
        assigns(:image).should be_persisted
      end

      it "redirects to the created image" do
        post :create, :image => valid_attributes, :lookbook_id => lookbook.id
        response.should redirect_to([:admin, Image.last.lookbook, Image.last])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved image as @image" do
        Image.any_instance.stub(:save).and_return(false)
        post :create, :image => {}, :lookbook_id => lookbook.id
        assigns(:image).should be_a_new(Image)
      end

      it "re-renders the 'new' template" do
        Image.any_instance.stub(:save).and_return(false)
        post :create, :image => {}, :lookbook_id => lookbook.id
        flash[:notice].should be_blank
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested image" do
        Image.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => image.id, :image => {'these' => 'params'}, :lookbook_id => lookbook.id
      end

      it "assigns the requested image as @image" do
        put :update, :id => image.id, :image => valid_attributes, :lookbook_id => lookbook.id
        assigns(:image).should eq(image)
      end

      it "redirects to the image" do
        put :update, :id => image.id, :image => valid_attributes, :lookbook_id => lookbook.id
        response.should redirect_to([:admin, lookbook, image])
      end
    end

    describe "with invalid params" do
      it "assigns the image as @image" do
        Image.any_instance.stub(:save).and_return(false)
        put :update, :id => image.id.to_s, :image => {}, :lookbook_id => lookbook.id
        assigns(:image).should eq(image)
      end

      it "re-renders the 'edit' template" do
        Image.any_instance.stub(:save).and_return(false)
        put :update, :id => image.id.to_s, :image => {}, :lookbook_id => lookbook.id
        flash[:notice].should be_blank
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested image" do
      expect {
        delete :destroy, :id => image.id.to_s, :lookbook_id => lookbook.id
      }.to change(Image, :count).by(-1)
    end

    it "redirects to the images list" do
      delete :destroy, :id => image.id.to_s, :lookbook_id => lookbook.id
      response.should redirect_to([:admin, lookbook])
    end
  end
end
