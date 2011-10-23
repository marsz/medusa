namespace :dev do 
  task :rebuild => ["db:drop","db:create","db:migrate","dev:fake"]
  task :fake do
    account = Account.create(:name => "marsz-proxymesh",:host => $proxy_config[:host], :port => $proxy_config[:port], :user=>$proxy_config[:user], :secret => $proxy_config[:password])
    spider = Spider.create(:ip => "us.proxymesh.com", :account => account, :connect_type => :proxy, :is_enabled => true)
  end
end