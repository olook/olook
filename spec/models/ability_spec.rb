require "cancan/matchers"

describe Admin do
  describe "abilities" do
    subject {ability}
    context "when a superadmin" do
      let(:admin) { FactoryGirl.create(:admin_superadministrator) }
      let(:ability) {Ability.new(admin) }
      
      it "should be able to manage everything" do
        should be_able_to(:manage, :all) 
      end
    end
    context "when a sac_operator" do
      let(:admin){ FactoryGirl.create(:admin_sac_operator) }
      let(:ability){ Ability.new(admin) }
      
      it "should be able to index Collection" do
        should be_able_to(:index, Collection)
      end
      
      it "should not be able to destroy Collection" do
        should_not be_able_to(:destroy, Collection)
      end
      
      it "should be able to edit Collection" do
        should be_able_to(:edit, Collection)
      end
    end
  end
end	
