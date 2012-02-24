module ActAsSpiderPickable
  extend ActiveSupport::Concern
  include ActAsDomainParsable
  
  module ClassMethods
    def pick_spider(url)
      domain = parse_domain(url)
      enabled_spider_ids = Spider.enabled.map{|spider|spider.id}
      spider_ids = DomainCrawling.where(:spider_id => enabled_spider_ids,:domain=>domain).order("crawled_at ASC").map{|domain_crawling|domain_crawling.spider_id}
      enabled_spider_ids.each do |spider_id|
        if !spider_ids.include?(spider_id)
          DomainCrawling.create!(:spider_id=>spider_id,:domain=>domain)
          spider_ids.unshift(spider_id)
        end
      end
      spider_ids.size > 0 ? Spider.find(spider_ids[0]) : nil
    end
    def crawled spider, url
      domain = parse_domain(url)
      domain_crawling = DomainCrawling.find_by_domain_and_spider_id(domain,spider.id) || DomainCrawling.create(:spider_id=>spider.id,:domain=>domain)
      domain_crawling.update_attributes(:crawled_at=>Time.now) if domain_crawling
    end
  end
  module InstanceMethods
  end

end