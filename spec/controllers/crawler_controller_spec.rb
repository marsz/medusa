require 'spec_helper'

describe CrawlerController do
  
  include DataMaker
  
  before do
    making_for_real_fetch
  end
  
  it { should route(:get, "/crawler/fetch").to(:action=>:fetch) }
  it { should route(:get, "/crawler/fetch.json").to(:action=>:fetch,:format=>:json) }
  
  it "get fetch normal" do
    get :fetch, :url => "http://www.google.com",:token => @app.token
    response.should be_success
  end
  
  it "post fetch normal" do
    post :fetch, :url => "http://www.bing.com",:token => @app.token
    response.should be_success
  end
  
  it "get fetch normal, test log" do
    get :fetch, :url => "http://www.google.com",:token => @app.token
    response.should be_success
    AppCrawling.all.size.should == 1
    get :fetch, :url => "http://www.google.com",:token => @app.token, :options => {:disable_log => true}
    response.should be_success
    AppCrawling.all.size.should == 1
  end
  
  it "post fetch without url" do
    expect {
      post :fetch, :token => @app.token
    }.to raise_error(RuntimeError)
  end
  
  it "get fetch without url" do
    expect {
      get :fetch, :token => @app.token
    }.to raise_error(RuntimeError)
  end
  
  describe "json format " do
    
    it "should respone 200 " do
      get 'fetch', :format => :json, :url => "http://www.google.com",:token => @app.token
      response.should be_success
      hash = ActiveSupport::JSON.decode(response.body)
      hash.is_a?(Hash).should == true
      hash["data"].size.should > 0
      hash["status"].should == 200
    end
    
    it "should respone 200 with https" do
      get 'fetch', :format => :json, :url => "https://github.com",:token => @app.token
      response.should be_success
      hash = ActiveSupport::JSON.decode(response.body)
      hash["data"].size.should > 0
      hash["status"].should == 200
    end
    
    it "should response 500" do
      get 'fetch', :format => :json, :url => "http://mmaarrsszz.com",:token => @app.token
      response.should be_success
      ActiveSupport::JSON.decode(response.body)["status"].should == 503
    end
    
    it "should response 403" do
      get 'fetch', :format => :json, :url => "http://a033755191.pixnet.net/blog/listall/1",:token => @app.token
      response.should be_success
      ActiveSupport::JSON.decode(response.body)["status"].should == 403
    end
    
    it "should response 404" do
      get 'fetch', :format => :json, :url => "http://www.google.com.tw/abvdefg",:token => @app.token
      response.should be_success
      ActiveSupport::JSON.decode(response.body)["status"].should == 404
    end
    
    it "should raise exception" do
      get 'fetch', :format => :json, :url => "dalskjd adskljdsa",:token => @app.token
      ActiveSupport::JSON.decode(response.body)["status"].should == 0
    end
    
  end
  
end
