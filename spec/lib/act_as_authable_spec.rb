require 'spec_helper'

shared_examples "act_as_authable" do
  
  include DataMaker
  
  before do
    making_for_real_fetch
    @request[:method] ||= :get
  end
  
  context "before_filter: authenticate_app" do
    
    it "success with token" do
      send(@request[:method],@request[:action], @request[:params].merge(:token => @app.token))
      response.should be_success
    end
    
    it "without token" do
      expect {
        send(@request[:method],@request[:action], @request[:params])
      }.to raise_error(RuntimeError)
    end
    
    it "with non-exists token" do
      expect {
        send(@request[:method],@request[:action], @request[:params].merge(:token => @app.token+"123"))
      }.to raise_error(RuntimeError)
    end

  end
end

describe CrawlerController do

  pending "not fix controller spec yet"
  
  before do
    @request = {:action=>:fetch, :params=>{:url=>"http://www.google.com"}}
  end
  # it_behaves_like "act_as_authable"
end
