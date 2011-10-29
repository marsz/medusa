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
  it {
    should validate_uniqueness_of(:ip)
  }
  it {should allow_value(:proxy).for(:connect_type)}
  it {should allow_value("proxy").for(:connect_type)}
  it {should_not allow_value(:abc).for(:connect_type)}
  describe "method - fetch" do
    it "normal + encoding" do
      url = "http://www.urcosme.com"
      content = @spider.fetch(url,nil,{:encoding=>"big5"})
      (content.size > 0).should == true
      (content.index("美") != nil).should == true
      (@spider.fetch(url).index("美") == nil).should == true
    end
  end
end
