require 'iconv'
module ActAsProxy
  extend ActiveSupport::Concern
  module ClassMethods
  end
  module InstanceMethods
    def fetch_by_proxy url, query_data = {}
      query_data ||= {}
      method = 'get' # TODO support post
      RestClient.proxy = "http://#{self.account.user}:#{self.account.secret}@#{get_host}:#{get_port}"
      begin
        RestClient.method(method).call(url, query_data)
      rescue => e
        handle_exception_from_fetch(e, url, query_data)
      end
    end
    
    private
    def get_port
      self.port || self.account.port
    end
    def get_host
      self.ip || self.account.host
    end
    def do_download url, save_file_path
      uri = URI.parse(url)
      Net::HTTP::Proxy(get_host,get_port,self.account.user,self.account.secret).start(uri.host, uri.port) do |http|
        response = http.get(uri.path)
        open(tmp_file_path, "wb") do |tmp_file|
          tmp_file.write(response.body)
          tmp_file.close
        end
      end
    end
    def handle_exception_from_fetch(e, url, query_data = {})
      if e.respond_to?(:http_code)
        e.http_code
      else
        case e
        when Net::HTTPBadResponse
          400
        else
          Airbrake.notify(e, :parameters => {:spider => self.id, :url => url, :query => query_data, :exception => e.inspect})
          0
        end
      end
    end
    
  end
end