require 'spec_helper'

describe SpidersController do
  before do
    @account = Factory(:account)
    @account2 = Factory(:account, :name => @account.name+"qqq")
  end
  it "post create" do
    spider = {:connect_type=>:proxy}
    post :create, :account_id => @account.id, :spider => spider
    response.status.should == 500
    spider[:ip] = "127.0.0.1"
    post :create, :account_id => @account.id, :spider => spider
    response.status.should == 200
    post :create, :account_id => @account2.id, :spider => spider
    response.status.should == 500
  end
  it "put update" do
    spider = Factory(:spider, :account_id => @account.id)
    hash = spider.attributes
    hash[:ip] = "127.0.0.2"
    put :update, :account_id => @account.id, :id=> spider.id, :spider => hash
    response.status.should == 200
    put :update, :account_id => @account2.id, :id=> spider.id, :spider => hash
    response.status.should == 500
  end
end
