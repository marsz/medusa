require 'spec_helper'

shared_examples_for "act_as_spider_pickable" do
  
  include DataMaker
  
  before do
    making_for_real_fetch
  end
  
  it "pick_spider" do
    url = "http://www.google.com"
    @klass.pick_spider(url).id.should == @spider.id
    @spider_sec = Factory :spider, :account_id => @account, :ip => "128.9.9.1"
    @klass.pick_spider(url).id.should == @spider_sec.id
    @klass.pick_spider(url).id.should == @spider.id
    DomainCrawling.all.size.should == 2
  end

  pending "#crawled"
end

describe "included classes" do
  
  before do
    @klass = DomainCrawling
  end
  
  it_should_behave_like "act_as_spider_pickable"
  
end
