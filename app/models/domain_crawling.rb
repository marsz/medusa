class DomainCrawling < ActiveRecord::Base
  include ActAsSpiderPickable
  scope :by_domain, lambda{|domain|where(:domain=>parse_domain(domain))}
  validates_uniqueness_of :domain, :scope => [:spider_id]
  validates_presence_of :domain
  validates_presence_of :spider_id
  
  belongs_to :spider
  
  before_validation :domain_refine
  
  protected
  def domain_refine
    self.domain = parse_domain(self.domain) || self.domain
    self.domain = self.domain.to_s.downcase.gsub(" ","")
  end
end
