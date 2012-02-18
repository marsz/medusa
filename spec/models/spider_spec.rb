# encoding: utf-8
require 'spec_helper'

describe Spider do
  include DataMaker
  before do
    making_for_real_fetch
  end
  
  it {should validate_presence_of(:connect_type)}
  it {should validate_presence_of(:account_id)}
  it {should validate_presence_of(:ip)}
  it {should validate_uniqueness_of(:ip)}
  it {should allow_value(:proxy).for(:connect_type)}
  # before validate :symbolize_connect_type
  it {should allow_value("proxy").for(:connect_type)}
  it {should_not allow_value(:abc).for(:connect_type)}
  it {should belong_to(:account)}
  
  describe "scopes" do
    it "enabled" do
      spider_enabled = Factory :spider_enabled
      spider_disabled = Factory :spider_disabled
      Spider.enabled.last.should == spider_enabled
      Spider.last.should == spider_disabled
    end
  end
  
  describe "method - validate" do
    it "validate false and true" do
      now = Time.now
      @spider.validate.should == true
      (@spider.last_validated_at >= now).should == true
      @spider.is_enabled.should == true
      @spider.update_attributes(:ip=>"0.0.0.0")
      @spider.validate.should == true
      @spider.is_enabled.should == false
    end
  end
  
  describe "#fetch" do
    it "normal + encoding" do
      url = "http://www.urcosme.com"
      content = @spider.fetch(url,nil,{:encoding=>"big5"})
      (content.size > 0).should == true
      (content.index("美") != nil).should == true
      @spider.fetch_success?.should == true
      (@spider.fetch(url).index("美") == nil).should == true
    end
  end
  
  describe "#download" do
    it "normal" do
      url = "http://f2.urcosme.com/images/logo.gif"
      new_file_url = @spider.download(url)
      storage = Storage.last
      storage.new_record?.should be_false
      storage.spider_id.should == @spider.id
      storage.url.should == new_file_url
      new_file_url.should_not be_nil
      storage.source_url.should == url
    end
  end
  
end
