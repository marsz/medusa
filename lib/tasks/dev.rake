namespace :dev do 
  task :rebuild => ["db:drop","db:create","db:migrate","dev:fake"]
  task :fake do
    account = Account.create(:name => "marsz-proxymesh",:host => "us.proxymesh.com", :port => 31280, :user=>"sogiProxy", :secret => "Proxy_Sogi")
    spider = Spider.create(:ip => "us.proxymesh.com", :account => account, :connect_type => :proxy, :is_enabled => true)
  end
end