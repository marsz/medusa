FactoryGirl.define do
  factory :app do
    name "marsz"
    token "1234"
  end

  factory :account do
    name "marsz-proxymesh"
    host $proxy_config[:host]
    port $proxy_config[:port]
    user $proxy_config[:user]
    secret $proxy_config[:password]
    
    factory :account_proxy do
    end
    
  end

  factory :spider do
    account_id 1
    ip $proxy_config[:host]
    connect_type :proxy
    is_enabled true
    
    factory :spider_proxy do
    end
    
    factory :spider_enabled do
      ip "129.9.9.9"
      is_enabled true
    end
    
    factory :spider_disabled do
      ip "129.8.8.8"
      is_enabled false
    end
  end

  factory :domain_crawling do
    domain "qqq"
    spider_id 1
  end
end