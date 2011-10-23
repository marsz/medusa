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
      RestClient.method(method).call(url, query_data)
    end
  end
end