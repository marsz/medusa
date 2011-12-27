require 'iconv'
module ActAsProxy
  extend ActiveSupport::Concern
  module ClassMethods
  end
  module InstanceMethods
    def fetch_by_proxy url, query_data = {}, options = {}
      query_data ||= {}
      method = options[:method] || 'get'
      port = self.port || self.account.port
      host = self.ip || self.account.host
      RestClient.proxy = "http://#{self.account.user}:#{self.account.secret}@#{host}:#{port}"
      begin
        RestClient.method(method).call(url, query_data)
      rescue => e
        handle_exception_from_fetch(e, url, query_data, options)
      end
    end
    
    private
    
    def handle_exception_from_fetch e, url, query_data = {}, options = {}
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