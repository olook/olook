require 'spec_helper'

describe Admin::PromotionsController do
  with_a_logged_admin do
    render_views

    before :all do
      Promotion.delete_all
    end

    let(:promotion) { FactoryGirl.create(:first_time_buyers) }
    let(:valid_attributes) { FactoryGirl.create(:first_time_buyers).attributes }
    let(:invalid_attributes) { {:name => nil } }

    describe "GET index" do
      it "should find all promotions" do
        get :index
        assigns(:promotions).should eq([promotion])
      end
    end

    describe "GET new" do
      it "assigns a new promotion as @promotion" do
        get :new
        assigns(:promotion).should be_a_new(Promotion)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Promotion" do
          expect {
            post :create, :promotion => valid_attributes
          }.to change(Promotion, :count).by(1)
        end

        it "assigns a newly created promotion as @promotion" do
          post :create, :promotion => valid_attributes
          assigns(:promotion).should be_a(Promotion)
          assigns(:promotion).should be_persisted
        end

        it "redirects to the created promotion" do
          post :create, :promotion => valid_attributes
          response.should redirect_to(admin_promotion_path(Promotion.last))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved promotion as @promotion" do
          # Trigger the behavior that occurs when invalid params are submitted
          Promotion.any_instance.stub(:save).and_return(false)
          post :create, :promotion => {}
          assigns(:promotion).should be_a_new(Promotion)
        end

        it "re-renders the 'new' template" do
          post :create, :promotion => invalid_attributes
          response.should render_template(:new)
        end
      end
    end

    describe "GET edit" do
      it "assigns the requested promotion as @promotion" do
        get :edit, :id => promotion.id.to_s
        assigns(:promotion).should eq(promotion)
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested promotion" do
          # Assuming there are no other promotions in the database, this
          # specifies that the Promotion created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Promotion.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => promotion.id, :promotion => {'these' => 'params'}
        end

        it "assigns the requested promotion as @promotion" do
          put :update, :id => promotion.id, :promotion => valid_attributes
          assigns(:promotion).should eq(promotion)
        end

        it "redirects to the promotion" do
          put :update, :id => promotion.id, :promotion => valid_attributes
          response.should redirect_to(admin_promotion_path(promotion))
        end
      end

      describe "with invalid params" do
        it "assigns the promotion as @promotion" do
          # Trigger the behavior that occurs when invalid params are submitted
          Promotion.any_instance.stub(:save).and_return(false)
          put :update, :id => promotion.id.to_s, :promotion => {}
          assigns(:promotion).should eq(promotion)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          #Promotion.any_instance.stub(:save, :errors => {:name => "blablabla"}).and_return(false)
          put :update, :id => promotion.id.to_s, :promotion => invalid_attributes
          response.should render_template(:edit)
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested promotion" do
        expect {
          delete :destroy, :id => promotion.id.to_s
        }.to change(Promotion, :count).by(-1)
      end

      it "redirects to the promotions list" do
        delete :destroy, :id => promotion.id.to_s
        response.should redirect_to(admin_promotions_url)
      end
    end
  end

end
