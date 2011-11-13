Factory.define :app do |f|
  f.name "marsz"
  f.token "1234"
end

Factory.define :account do |f|
  f.name "marsz-proxymesh"
  f.host $proxy_config[:host]
  f.port $proxy_config[:port]
  f.user $proxy_config[:user]
  f.secret $proxy_config[:password]
end

Factory.define :spider do |f|
  f.account_id 1
  f.ip $proxy_config[:host]
  f.connect_type :proxy
  f.is_enabled true
end

Factory.define :domain_crawling do |f|
  f.domain "www.qqq.com"
  f.spider_id 1
end