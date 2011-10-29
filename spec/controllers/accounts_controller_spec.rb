require 'spec_helper'

describe AccountsController do
  it "create with spiders..." do 
    account = {}
    post :create, :account => account
    response.status.should == 500
    account[:name] = "account 1"
    post :create, :account => account
    response.status.should == 200
    spider = {:connect_type => :proxy, :is_enabled => true}
    account[:spiders] = [spider.merge(:ip=>"127.0.0.1"), spider.merge(:ip=>"127.0.0.2")]
    account[:name] = "account 2"
    post :create, :account => account
    response.status.should == 200
    Account.find(response.body.to_i).spiders.size.should == account[:spiders].size
  end
  it "update with spiders..." do 
    account = Factory(:account)
    account.name = "aws..."
    put :update, :id => account.id, :account => account.attributes
    response.status.should == 200
    spider = {:connect_type => :proxy, :is_enabled => true}
    spiders = [spider.merge(:ip=>"127.0.0.1"), spider.merge(:ip=>"127.0.0.2")]
    put :update, :id => account.id, :account => account.attributes.merge(:spiders=>spiders)
    response.status.should == 200
    account = Account.find(account.id)
    account.spiders.size.should == spiders.size
    spider = account.spiders.first
    spider.is_enabled = true
    put :update, :id => account.id, :account => {:spiders=>[spider.attributes]}
    spider.reload
    spider.is_enabled.should == true
  end
end
