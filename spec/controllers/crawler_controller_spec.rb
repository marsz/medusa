require 'spec_helper'

describe CrawlerController do
  include DataMaker
  before do
    making_for_real_fetch
  end
  it "get fetch normal" do
    get :fetch, :url => "http://www.google.com",:token => @app.token
    response.status.should == 200
  end
  it "post fetch normal" do
    post :fetch, :url => "http://www.bing.com",:token => @app.token
    response.status.should == 200
  end
  it "get fetch normal, test log" do
    get :fetch, :url => "http://www.google.com",:token => @app.token
    response.status.should == 200
    AppCrawling.all.size.should == 1
    get :fetch, :url => "http://www.google.com",:token => @app.token, :options => {:disable_log => true}
    response.status.should == 200
    AppCrawling.all.size.should == 1
  end
  it "post fetch without url" do
    post :fetch, :token => @app.token
    response.status.should == 500
  end
  it "get fetch without url" do
    get :fetch, :token => @app.token
    response.status.should == 500
  end
  it "get fetch without token" do
    get :fetch, :url => "http://www.google.com"
    response.status.should == 500
  end
  it "get fetch with non-exists token" do
    get :fetch, :url => "http://www.google.com", :token => @app.token+"123"
    response.status.should == 500
  end
  it "get fetch respond json" do
    get 'fetch', :format => :json, :url => "http://www.google.com",:token => @app.token
    response.status.should == 200
    ActiveSupport::JSON.decode(response.body).is_a?(Hash).should == true
  end
end
