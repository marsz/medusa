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
    def crawling(url, query = {}, options = {})
      if options[:ip]
        spider = Spider.find_by_ip_and_is_enabled(options[:ip], true)
      else
        spider = pick_spider(url)
      end
      # logger.debug "---------------------"+spider.inspect
      if spider
        result = spider.fetch(url, query, options)
        if spider.fetch_success?
          domain = parse_domain(url)
          DomainCrawling.find_by_domain_and_spider_id(domain,spider.id).update_attributes(:crawled_at=>Time.now)
          result
        else
          spider.response_code
        end
      else
        raise "no spider for crawling"
      end
    end
  end
  module InstanceMethods
  end

end