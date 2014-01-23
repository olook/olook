require 'spec_helper'

describe PostRetrieverService do
  subject do
    Rubypress::Client.should_receive(:new).and_return(nil)
    PostRetrieverService.new("","","","")
  end

  context "#gather" do
    context "when wordpress returns the data" do
      it "writes the hash in the cache" do
        subject.should_receive(:retrieve_post_data).and_return([{link: "link1", title: "title1", subtitle: "subtitle1", img_old_home: "img_old_1",img_new_home: "img_new_1"}])
        Rails.cache.should_receive(:write).with("sn-post-data", [{link: "link1", title: "title1", subtitle: "subtitle1", img_old_home: "img_old_1",img_new_home: "img_new_1"}], :time_to_live => 1.hour)
        subject.gather_posts
      end

      it "processes the images and formats the post hashes" do
        subject.should_receive(:posts).and_return([{"link" => "link1", "post_title" => "title1", "post_thumbnail" => {"link" => "img_url"}, "custom_fields" => [{"key" => "wps_subtitle", "value" => "subtitle1"}]}])
        subject.should_receive(:process_images).and_return({img_old_home: "img_old_1",img_new_home: "img_new_1"})
        subject.gather_posts
      end

      it "writes the hash in the cache correctly" do
        subject.should_receive(:posts).and_return([{"link" => "link1", "post_title" => "title1", "post_thumbnail" => {"link" => "img_url"}, "custom_fields" => [{"key" => "wps_subtitle", "value" => "subtitle1"}]}])
        subject.should_receive(:process_images).and_return({img_old_home: "img_old_1",img_new_home: "img_new_1"})

        Rails.cache.should_receive(:write).with("sn-post-data", [{link: "link1", title: "title1", subtitle: "subtitle1", img_old_home: "img_old_1",img_new_home: "img_new_1"}], :time_to_live => 1.hour)
        subject.gather_posts
      end        
    end
  end

  context "#retrieve_posts" do
    it "retrieves the posts" do
      subject.should_receive(:retrieve_post_data).and_return([{link: "link1", title: "title1", subtitle: "subtitle1", img_old_home: "img_old_1",img_new_home: "img_new_1"}])
      subject.retrieve_posts
    end
  end  
end
