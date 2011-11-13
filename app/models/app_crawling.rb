class AppCrawling < ActiveRecord::Base
  include ActAsDomainParsable
  validates_presence_of :app_id
  validates_presence_of :url
  
  before_save :retrieve_domain
  belongs_to :app
  
  protected
  def retrieve_domain
    self.domain = AppCrawling.parse_domain(self.url)
  end
end
