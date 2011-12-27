Airbrake.configure do |config|
  if ["production","development"].include?(Rails.env)
    begin
      config.api_key = YAML.load(File.open('config/airbrake.yml'))[Rails.env][:api_key]
    rescue Errno::ENOENT
      puts "warring: you don't have set config/airbrake.yml"
    end
  end
  # config.development_environments = ["test"]
end
