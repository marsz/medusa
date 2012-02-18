require 'net/http'
require 'iconv'
module ActAsProxy
  extend ActiveSupport::Concern
  module ClassMethods
  end
  module InstanceMethods
    def download_by_proxy url
      ext = File.extname url
      tmp_file_path = "#{Rails.root}/tmp/#{Digest::MD5.hexdigest(Time.now.to_s)}#{ext}"
      result = do_download url, tmp_file_path
      return result if result.is_a?(Fixnum)
      if storage = Storage.create_by_source_url_and_spider(url,self)
        storage.upload(tmp_file_path)
      end
      File.delete tmp_file_path if File.exists?(tmp_file_path)
      storage
    end
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
      begin
        uri = URI.parse(url)
      rescue
        return 0
      end
      return 0 if uri.path.empty?
      http_session = Net::HTTP::Proxy(get_host,get_port,self.account.user,self.account.secret)
      http_session.start(uri.host, uri.port) do |http|
        if url.downcase.index("https") == 0
          http = http_session.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          http = http.start
        end
        response = http.get(uri.path)
        return response.code.to_i if response.code.to_i != 200
        open(save_file_path, "wb") do |tmp_file|
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