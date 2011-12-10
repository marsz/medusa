require 'spec_helper'

shared_examples_for "act_as_domain_parsable" do
  before do
    @urls = ["http://www.google.com", "http://www.google.com.tw", 
        "http://www.google.cc", "http://www.google.edu.tw",
        "http://mail.google.edu.tw", "http://www.GOOGLE.com.tw"
      ]
    @domain = "google"
  end
  it "parse_domain" do
    @urls.each do |url|
      @klass.parse_domain(url).should == @domain
      @klass.new.parse_domain(url).should == @domain
    end
  end
end

describe "included classes" do
  before do
    @klass = DomainCrawling
  end
  it_should_behave_like "act_as_domain_parsable"
end