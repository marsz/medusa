shared_examples_for "fetch_by_connect_type" do
  
  describe "fetch_by_connect_type" do
    
    it "method exists" do
      @spider.should respond_to("fetch_by_#{@connect_type}")
    end
    
    it "normal url" do
      url = "http://www.google.com.tw"
      @spider.send("fetch_by_#{@connect_type}", url).should be_a_kind_of(String)
    end

    it "normal url with params" do
      url = "http://www.bing.com/search"
      @spider.send("fetch_by_#{@connect_type}", url, {:q=>"hot"}).index("hot").should >= 0
    end
    
    it "dns error url" do
      url = "http://www.mmaarrsszzoonnee.tw"
      @spider.send("fetch_by_#{@connect_type}", url).should == 503
    end
        
    it "ip error url" do
      url = "http://256.256.256"
      @spider.send("fetch_by_#{@connect_type}", url).should == 0
    end
    
    it "404 url" do
      url = "http://www.google.com.tw/abvdefg"
      @spider.send("fetch_by_#{@connect_type}", url).should == 404
    end
    
    it "invalid url" do
      url = "oh my gooddness"
      @spider.send("fetch_by_#{@connect_type}", url).should == 0
    end

    it "https url" do
      url = "https://github.com"
      @spider.send("fetch_by_#{@connect_type}", url).size.should > 0
    end
    
    it "403 url" do
      url = "http://a033755191.pixnet.net/blog/listall/1"
      @spider.send("fetch_by_#{@connect_type}", url).should == 403
    end
    
    # urls = {
    #   :normal => "http://www.google.com.tw",
    #   :dns_error => "http://wwwmmaarrsszzcom",
    #   :ip_error => "http://256.256.256.256",
    #   :not_found => "http://www.google.com.tw/abvdefg",
    #   :https => "https://github.com"
    # }
    # urls.each do |state, url|
    #   it "#{state} url" do
    #     @spider.send("fetch_by_#{@connect_type}", url)
    #   end
    # end
  end
  
end
