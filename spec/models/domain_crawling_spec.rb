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
  
  it "before save: domain_refine" do
    @instance.update_attributes(:domain => @domain.upcase)
    domain_crawling = DomainCrawling.find(@instance.id)
    domain_crawling.domain.should == @instance.domain.downcase
  end
  
  describe "scopes" do
    it "by_domain" do
      domain_crawling = Factory(:domain_crawling, :domain => "foo")
      DomainCrawling.by_domain("foo").first.should == domain_crawling
      DomainCrawling.by_domain("www.foo.com").first.should == domain_crawling
    end
  end
  
end
