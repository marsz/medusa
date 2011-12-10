require 'spec_helper'

describe SpidersController do
  
  before do
    @account = Factory(:account)
    @account2 = Factory(:account, :name => @account.name+"qqq")
  end
  
  it { should route(:get,"/accounts/#{@account.name}/spiders/validate").to(:action=>:validate,:account_id=>@account.name) }
  it { should route(:post,"/accounts/#{@account.name}/spiders/validate").to(:action=>:validate,:account_id=>@account.name) }
  it { should route(:post,"/accounts/#{@account.name}/spiders").to(:action=>:create,:account_id=>@account.name) }
  it { should route(:put,"/accounts/#{@account.name}/spiders/1").to(:action=>:update,:account_id=>@account.name,:id=>1) }
  it { should route(:delete,"/accounts/#{@account.name}/spiders/1").to(:action=>:destroy,:account_id=>@account.name,:id=>1) }
  
  
  describe "#validate" do
    it "account_id = name" do
      get :validate, :account_id => @account.name
      response.should be_success
    end
    
    it "account_id = id" do
      post :validate, :account_id => @account.id
      response.should be_success
    end
    
    it "account_id not found" do
      get :validate, :account_id => @account.name+"123"
      response.should_not be_success
    end
  end
  
  describe "post create" do
    it "create fail" do
      spider = {:connect_type => :xxxx}
      post :create, :account_id => @account.id, :spider => spider
      response.should_not be_success
    end
    
    it "create success but can't create another with same ip" do
      spider = {:connect_type => :proxy, :ip => "127.0.0.1"}
      post :create, :account_id => @account.name, :spider => spider
      response.should be_success
      post :create, :account_id => @account2.id, :spider => spider
      response.should_not be_success
    end
  end
  
  it "put update" do
    spider = Factory(:spider, :account_id => @account.id)
    hash = spider.attributes
    hash[:ip] = "127.0.0.2"
    put :update, :account_id => @account.id, :id=> spider.id, :spider => hash
    response.should be_success
  end
  
  it "delete destroy" do
    spider = Factory(:spider, :account_id => @account.id)
    delete :destroy, :account_id => @account.name, :id => spider.id
    response.should be_success
    Spider.exists?(spider.id).should == false
  end
  
end
