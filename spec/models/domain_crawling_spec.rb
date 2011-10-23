require 'spec_helper'

describe DomainCrawling do
  before do 
    @instance = Factory(:domain_crawling)
    @domain = "www.#{@instance.domain.upcase}.com"
    @spider = Factory(:spider)
  end
  it {should validate_presence_of(:domain)}
  it {should validate_presence_of(:spider_id)}
  it {should belong_to(:spider)}
  it {
    should validate_uniqueness_of(:domain).scoped_to(:spider_id)
  }
  it "downcase before save" do
    @instance.update_attributes(:domain => @domain.upcase)
    DomainCrawling.find(@instance.id).domain.should == @domain.downcase
  end
  
  it "pick spider" do 
    if DomainCrawling.ancestors.include?(ActAsSpiderPickable)
      disabled_spider = Factory(:spider, :is_enabled=>false,:ip=>'127.0.0.2')
      another_spider = Factory(:spider, :ip=>'127.0.0.3')
      spider = DomainCrawling.pick_spider("http://#{@domain}")
      spider.should_not == nil
      # puts DomainCrawling.all.inspect
      search = DomainCrawling.by_domain(@domain.downcase)
      # puts search.where(:spider_id=>spider.id).to_sql
      search.where(:spider_id=>spider.id).count.should == 1
      search.where(:spider_id=>disabled_spider.id).count.should == 0
      search.where(:spider_id=>another_spider.id).count.should == 1
    end
  end
end
