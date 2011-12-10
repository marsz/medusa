require 'spec_helper'

describe AccountsController do
  it { should route(:post, "/accounts").to(:action=>:create) }
  it { should route(:put, "/accounts/1").to(:action=>:update,:id=>1) }
  
  it "post create" do 
    account = {}
    post :create, :account => account
    response.should_not be_success
    account[:name] = "account 1"
    post :create, :account => account
    response.should be_success
    account[:name] = "account 2"
    post :create, :account => account
    response.should be_success
    Account.last.name.should == account[:name]
  end
  it "put update" do 
    account = Factory(:account)
    name = "aws"
    put :update, :id => account.id, :account => {:name => name}
    response.should be_success
    account.reload
    account.name.should == name
  end
end
