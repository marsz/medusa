Factory.define :account do |f|
  f.name "marsz-proxymesh"
  f.host "us.proxymesh.com"
  f.port 31280
  f.user "sogiProxy"
  f.secret "Proxy_Sogi"
end

Factory.define :spider do |f|
  f.account_id 1
  f.ip "us.proxymesh.com"
  f.connect_type :proxy
  f.is_enabled true
end

Factory.define :domain_crawling do |f|
  f.domain "www.qqq.com"
  f.spider_id 1
end