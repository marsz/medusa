require 'spec_helper'

describe CrawlerController do
  before do
    init_for_api_request
    making_for_real_fetch
  end

  describe "#fetch" do
    it "success with refer" do
      data = request_api :get, "/crawler/fetch.json?token=#{@app.token}", :url => "http://www.google.com"
      response.should be_success
    end
  end


end
