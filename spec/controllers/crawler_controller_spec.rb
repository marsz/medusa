require 'spec_helper'

describe CrawlerController do
  include DataMaker
  before do
    making_for_real_fetch
  end
  it "fetching...." do
    get :fetch, :url => "http://www.google.com"
    response.status.should == 200
    post :fetch, :url => "http://www.bing.com"
    response.status.should == 200
    post :fetch
    response.status.should == 500
    get :fetch
    response.status.should == 500
    get 'fetch', :format => :json, :url => "http://www.google.com"
    response.status.should == 200
    ActiveSupport::JSON.decode(response.body).is_a?(Hash).should == true
  end
end
