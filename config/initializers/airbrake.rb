Airbrake.configure do |config|
  if ["production","development"].include?(Rails.env)
    config.api_key = YAML.load(File.open('config/airbrake.yml'))[Rails.env][:api_key]
  end
  # config.development_environments = ["test"]
end
