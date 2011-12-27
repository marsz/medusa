namespace :cron do

  task :validate_spiders => :environment do
    Spider.all.each do |spider|
      spider.validate
    end
  end

  namespace :builder do
    task :trigger => :environment do
      begin
        hook_key = "medusa-#{Rails.env}"
        config = YAML.load_file("#{Rails.root}/config/builder.yml")[Rails.env]
        url = "http://#{config[:host]}/hooks/build/#{hook_key}"
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        request.basic_auth(config[:user], config[:password])
        response = http.request(request)
      rescue Errno::ENOENT
        puts "Error: please setup builder.yml to trigger builder"
      end
    end
  end

end