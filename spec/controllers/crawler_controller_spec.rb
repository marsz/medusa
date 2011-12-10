require 'spec_helper'

describe CrawlerController do
  
  include DataMaker
  
  before do
    making_for_real_fetch
  end
  
  it { should route(:get, "/crawler/fetch").to(:action=>:fetch) }
  
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
  
  it "get fetch respond json" do
    get 'fetch', :format => :json, :url => "http://www.google.com",:token => @app.token
    response.should be_success
    ActiveSupport::JSON.decode(response.body).is_a?(Hash).should == true
  end
end
