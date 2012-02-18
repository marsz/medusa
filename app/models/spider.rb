class Spider < ActiveRecord::Base
  include ActAsProxy
  act_as_proxy

  scope :enabled, where(:is_enabled=>true)  
  validates_uniqueness_of :ip
  validates_presence_of :ip
  validates_presence_of :connect_type
  validates_presence_of :account_id
  validates_inclusion_of :connect_type, :in => [:proxy]
  before_validation :symbolize_connect_type
  belongs_to :account

  attr_reader :response_code
  
  def download url
    storage = send "download_by_#{connect_type}", url
    set_response_code(storage)
    fetch_success? ? storage.url : nil
  end
  
  def fetch url, query_data = {}, options = {}
    query_data ||= {}
    encode = options[:encoding] || 'UTF-8'
    content = method("fetch_by_#{connect_type}").call(url,query_data)
    set_response_code(content)
    fetch_success? ? Iconv.new('UTF-8//IGNORE', encode).iconv(content) : nil
  end
  
  def fetch_success?
    @response_code == 200
  end

  def validate options = {}
    url = options[:url] || "http://www.bing.com/"
    begin
      fetch(url)
      is_enabled = fetch_success?
    rescue
      is_enabled = false
    end
    self.update_attributes(:is_enabled => is_enabled, :last_validated_at => Time.now)
  end
  
  protected
  
  def symbolize_connect_type
    self.connect_type = self.connect_type.to_sym if self.connect_type
  end
  
  def set_response_code content
    @response_code = content.is_a?(Fixnum)? content : 200
  end
end
