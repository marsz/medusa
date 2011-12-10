require 'spec_helper'

describe AppCrawling do
  include DataMaker
  before do
    making_for_real_fetch
  end
  it {should validate_presence_of(:app_id)}
  it {should validate_presence_of(:url)}
  it {should belong_to(:app)}
  
  it "retrieve_domain automatically" do
    url = "http://www.google.com"
    app_crawling = AppCrawling.create(:app => @app, :url => url)
    app_crawling.domain.should == "google"
  end
end
