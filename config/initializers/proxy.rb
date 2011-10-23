if ["development","test"].include?(Rails.env)
  begin
    $proxy_config = ActiveSupport::HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/config/proxymesh.yml")[Rails.env]).symbolize_keys
  rescue
    puts "u need to set config/proxymesh.yml"
    $proxy_config = {}
  end
end
