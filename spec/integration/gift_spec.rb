 # -*- encoding : utf-8 -*-
require 'spec_helper'
require 'integration/helpers'

feature "Buying Gifts", %q{
  In order to buy a gift for a special person
  As a user
  I want to be able to choose and buy the correct product
  } do
    
  let!(:user) { Factory.create(:user) }
  let!(:occasion_type) { Factory.create(:gift_occasion_type) }
  let!(:recipient_relation) { Factory.create(:gift_recipient_relation) }
  let!(:gift_survey) { Factory.create(:gift_question) }
    
  describe "Already user" do
    background do
      do_login!(user)
    end
    
    scenario "visiting the gift project landing page/home" do
      visit gift_root_path
      page.should have_content("Acerte em cheio no presente")
    end
    
    describe "going through all gift process" do
      
      before :each do 
        visit gift_root_path
        click_link "new_occasion_link"
      end

      scenario "starting the process of creating a gift" do
        page.should have_content("Estou escolhendo um presente")
      end

      scenario "filling data and being redirect to quiz page" do
        fill_in 'recipient_name', :with => 'Jonh Doe'
        select occasion_type.name, :from => 'occasion_gift_occasion_type_id'
        select recipient_relation.name, :from => 'recipient_gift_recipient_relation_id'
        click_button "Continuar"
        page.should have_content( gift_survey.title )
      end

      scenario "answering the quiz for my recipient" do
      end

    end
    
    scenario "viewing my recipient profile and choosing her shoe size" do
      pending
    end
    
    scenario "choosing some products for my recipient" do
      pending
    end
    
    scenario "checking out" do
      pending
    end
      
    describe "with facebook" do
      scenario "create gift for a facebook friend" do
        pending
      end
    end
    
    describe "log to facebook" do
      pending
    end
  end
  
  describe "logged out" do
    scenario "should see the landing page with disabled calendar" do
      visit gift_root_path
      page.should have_content("Acerte em cheio no presente")
      page.has_css?('.opacity')
    end
    
    scenario "should start the gift creation" do
      visit gift_root_path
      click_link "new_occasion_link"
      page.should have_content("Estou escolhendo um presente")
    end
    
    scenario "should see the suggestions for a gift recipient" do
      FactoryGirl.create(:gift_occasion_type)
      FactoryGirl.create(:gift_recipient_relation)
      FactoryGirl.create(:answer, :question => gift_survey)
      visit gift_root_path
      click_link "new_occasion_link"
      fill_in "recipient_name", :with => "Jane Joe"
      select "funeral", :from => "occasion_gift_occasion_type_id"
      select "Avó", :from => "recipient_gift_recipient_relation_id"
      click_button "Continuar"
      #choose "questions_question_1_1"
      pending
    end
  end
end

