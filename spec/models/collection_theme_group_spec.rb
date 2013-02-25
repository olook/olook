require 'spec_helper'

describe CollectionThemeGroup do
  context "validation testing" do
    it "isn't valid if the entity doesn't have a name" do
      expect(CollectionThemeGroup.new(position: 2)).to_not be_valid
    end
    it "is valid if the entity has a name" do
      expect(CollectionThemeGroup.new(position: 2, name: "Ronaldo")).to be_valid
    end    
  end

  context "position changing" do
    it "assigns a position for new entities" do
      collection_theme_group = CollectionThemeGroup.create(name: "teste")
      expect(collection_theme_group.position).to be_eql(1) 
    end

    it "puts the newly created group to the last position" do
      CollectionThemeGroup.create(name: "fsad", position: 2)
      CollectionThemeGroup.create(name: "fsadas", position: 4)
      collection_theme_group = CollectionThemeGroup.create(name: "teste")
      expect(collection_theme_group.position).to be_eql(5) 
    end

    it "puts the newly created group to the last position" do
      CollectionThemeGroup.create(name: "fsad")
      second_theme_group = CollectionThemeGroup.create(name: "fsadas", position: 2)
      CollectionThemeGroup.create(name: "fsad")
      collection_theme_group = CollectionThemeGroup.create(name: "teste", position: 2)    
      second_theme_group.reload
      expect(collection_theme_group.position).to be_eql(2)
      expect(second_theme_group.position).to be_eql(3) 
    end  

    it "reallocates all groups when a position is updated" do
      CollectionThemeGroup.create(name: "fsad")
      second_theme_group = CollectionThemeGroup.create(name: "fsadas")
      CollectionThemeGroup.create(name: "fsad")
      collection_theme_group = CollectionThemeGroup.create(name: "teste")
      expect(collection_theme_group.position).to be_eql(4)    
      collection_theme_group.update_attribute(:position, 2)
      expect(collection_theme_group.position).to be_eql(2)
      second_theme_group.reload
      expect(second_theme_group.position).to be_eql(3) 
    end

    it "reallocates all groups positions when an entity is deleted" do
      CollectionThemeGroup.create(name: "fsad")
      CollectionThemeGroup.create(name: "fsad")
      collection_theme_group = CollectionThemeGroup.create(name: "teste")
      second_theme_group = CollectionThemeGroup.create(name: "fsadas")
      expect(collection_theme_group.position).to be_eql(3)    
      collection_theme_group.destroy
      second_theme_group.reload
      expect(second_theme_group.position).to be_eql(3) 
    end      
  end
end
