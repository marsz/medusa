namespace :cron do
  task :validate_spiders => :environment do
    Spider.all.each do |spider|
      spider.validate
    end
  end
end