require 'spec_helper'

describe PostRetrieverService do
  subject do
    Rubypress::Client.should_receive(:new).and_return(nil)
    PostRetrieverService.new("","","","")
  end
  before do
    @redis = mock('Redis')
    Redis.should_receive(:connect).and_return(@redis)
  end

  context "#gather" do
    context "when wordpress returns the data" do
      it "writes the hash in the cache" do
        @redis.should_receive(:setex).with("sn-post-data", 1.hour, {data: [{link: "link1", title: "title1", subtitle: "subtitle1", img_old_home: "img_old_1",img_new_home: "img_new_1"}]}.to_json)
        subject.should_receive(:retrieve_post_data).and_return([{link: "link1", title: "title1", subtitle: "subtitle1", img_old_home: "img_old_1",img_new_home: "img_new_1"}])
        subject.gather_posts
      end

      it "processes the images and formats the post hashes" do
        subject.should_receive(:posts).and_return([{"link" => "link1", "post_title" => "title1", "post_thumbnail" => {"link" => "img_url"}, "custom_fields" => [{"key" => "wps_subtitle", "value" => "subtitle1"}]}])
        subject.should_receive(:process_images).and_return({img_old_home: "img_old_1",img_new_home: "img_new_1"})
        @redis.should_receive(:setex).with("sn-post-data", 1.hour, {data: [{link: "link1", title: "title1", subtitle: "subtitle1", img_old_home: "img_old_1",img_new_home: "img_new_1"}]}.to_json)
        subject.gather_posts
      end

      it "writes the hash in the cache correctly" do
        subject.should_receive(:posts).and_return([{"link" => "link1", "post_title" => "title1", "post_thumbnail" => {"link" => "img_url"}, "custom_fields" => [{"key" => "wps_subtitle", "value" => "subtitle1"}]}])
        subject.should_receive(:process_images).and_return({img_old_home: "img_old_1",img_new_home: "img_new_1"})

        @redis.should_receive(:setex).with("sn-post-data", 1.hour, {data: [{link: "link1", title: "title1", subtitle: "subtitle1", img_old_home: "img_old_1",img_new_home: "img_new_1"}]}.to_json)
        subject.gather_posts
      end
    end
  end

  context "#retrieve_posts" do
    it "retrieves the posts" do
      @redis.should_receive(:exists).with('sn-post-data').and_return(false)
      subject.should_receive(:retrieve_post_data).and_return([{link: "link1", title: "title1", subtitle: "subtitle1", img_old_home: "img_old_1",img_new_home: "img_new_1"}])
      @redis.should_receive(:setex).with("sn-post-data", 1.hour, {data: [{link: "link1", title: "title1", subtitle: "subtitle1", img_old_home: "img_old_1",img_new_home: "img_new_1"}]}.to_json)
      subject.retrieve_posts
    end
  end
end
