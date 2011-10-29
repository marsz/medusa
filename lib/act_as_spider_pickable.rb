module ActAsSpiderPickable
  extend ActiveSupport::Concern
  module ClassMethods
    def pick_spider(url)
      domain = Domainatrix.parse(url).domain
      enabled_spider_ids = Spider.enabled.map{|spider|spider.id}
      spider_ids = DomainCrawling.where(:spider_id => enabled_spider_ids).order("crawled_at ASC").map{|domain_crawling|domain_crawling.spider_id}
      enabled_spider_ids.each do |spider_id|
        if !spider_ids.include?(spider_id)
          DomainCrawling.create!(:spider_id=>spider_id,:domain=>domain)
          spider_ids.unshift(spider_id)
        end
      end
      spider_ids.size > 0 ? Spider.find(spider_ids[0]) : nil
    end
    def parse_domain(url)
      tmp = (url.to_s.index("http") != 0) ? "http://#{url}" : url
      tmp = Domainatrix.parse(tmp) rescue nil
      return tmp ? tmp.domain : url
    end
    def crawling(url, query = {}, options = {})
      if spider = pick_spider(url)
        spider.fetch(url, query, options)
      else
        raise "no spider for crawling"
      end
    end
  end
  module InstanceMethods
  end

end