class Spider < ActiveRecord::Base
  include ActAsProxy

  scope :enabled, where(:is_enabled=>true)  
  validates_uniqueness_of :ip
  validates_presence_of :ip
  validates_presence_of :connect_type
  validates_presence_of :account_id
  validates_inclusion_of :connect_type, :in => [:proxy]
  before_validation :symbolize_connect_type
  belongs_to :account
  
  def fetch url, query_data = {}, options = {}
    query_data ||= {}
    encode = options[:encoding] || 'UTF-8'
    content = method("fetch_by_#{connect_type}").call(url,query_data, options)
    Iconv.new('UTF-8//IGNORE', encode).iconv(content)
  end
  protected
  def symbolize_connect_type
    self.connect_type = self.connect_type.to_sym if self.connect_type
  end
end
