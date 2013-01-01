module ApiClient
  def request_api(verb, path, querys = {})
    querys[:token] ||= @app.token if @app
    querys[:format] ||= :json
    send verb, "http://example.com#{path}", querys, @request_header
    ActiveSupport::JSON.decode(response.body) rescue nil
  end

  def init_for_api_request
    @app ||= FactoryGirl.create :app, :limited_domains => "example.cc,foo.com"
    @request_header = { "HTTP_REFERER" => @app.limited_domains.gsub(" ","").split(",").first }
  end

end