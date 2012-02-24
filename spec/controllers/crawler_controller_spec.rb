require 'spec_helper'

shared_examples_for "bad_urls" do
  before do
    @action.should_not be_nil
    @app.should_not be_nil
  end
  it "should response 503" do
    get @action, :format => :json, :url => "http://mmaarrsszz.com/zzzz",:token => @app.token
    response.should be_success
    ActiveSupport::JSON.decode(response.body)["status"].should == 503
  end
  
  it "should response 403" do
    get @action, :format => :json, :url => "http://a033755191.pixnet.net/blog/listall/1",:token => @app.token
    response.should be_success
    ActiveSupport::JSON.decode(response.body)["status"].should == 403
  end
  
  it "should response 404" do
    get @action, :format => :json, :url => "http://www.google.com.tw/abvdefg",:token => @app.token
    response.should be_success
    ActiveSupport::JSON.decode(response.body)["status"].should == 404
  end
  
  it "should raise exception" do
    get @action, :format => :json, :url => "dalskjd adskljdsa",:token => @app.token
    ActiveSupport::JSON.decode(response.body)["status"].should == 0
  end
  
end

describe CrawlerController do
  
  include DataMaker
  
  before do
    making_for_real_fetch
  end
  
  describe "routes" do
    it { should route(:get, "/crawler/fetch").to(:action=>:fetch) }
    it { should route(:get, "/crawler/fetch.json").to(:action=>:fetch,:format=>:json) }
    it { should route(:get, "/crawler/download").to(:action=>:download) }
    it { should route(:get, "/crawler/download.json").to(:action=>:download,:format=>:json) }
  end
  
  
  describe "#fetch" do
    it "with options[ip]" do
      spider = Spider.first
      get :fetch, :url => "http://www.google.com",:token => @app.token, :options => {:ip => spider.ip}
      response.should be_success
    end
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
      before do
        @action = "fetch"
      end
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
      it_should_behave_like "bad_urls"
    end
  end
  describe "#download" do
    before do
      @action = "download"
    end
    it_should_behave_like "bad_urls"
    it "normal" do
      get "download", :format => :json, :url => "http://f2.urcosme.com/images/logo.gif",:token => @app.token
      response.should be_success
      hash = ActiveSupport::JSON.decode(response.body)
      hash["url"].size.should > 0
      hash["status"].should == 200
    end
    it "304 cached" do
      get "download", :format => :json, :url => "http://f2.urcosme.com/images/logo.gif",:token => @app.token
      size = Storage.scoped.count
      log_id = DomainCrawling.last.id
      get "download", :format => :json, :url => "http://f2.urcosme.com/images/logo.gif",:token => @app.token
      Storage.scoped.count.should == size
      DomainCrawling.last.id.should == log_id
      hash = ActiveSupport::JSON.decode(response.body)
      hash["status"].should == 304
    end
    it "https" do
      get "download", :format => :json, :url => "https://secure.gravatar.com/avatar/0b2f434918eb4a08439d180a13829631",:token => @app.token
      response.should be_success
      hash = ActiveSupport::JSON.decode(response.body)
      hash["url"].size.should > 0
      hash["status"].should == 200
    end
    pending "with referer"
    pending "url with paramters"
  end
end
