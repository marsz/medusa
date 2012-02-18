unless ["test"].include?(Rails.env)
  begin
    config = ActiveSupport::HashWithIndifferentAccess.new YAML.load_file("#{Rails.root}/config/fog.yml")[Rails.env]
    $fog = Fog::Storage.new(:provider => 'AWS', :aws_access_key_id => config[:aws][:access_key_id], :aws_secret_access_key => config[:aws][:secret_access_key])
    $fog = $fog.directories.select{ |dir| dir.key == config[:aws][:bucket] }[0]
  rescue
    p "fog config initial error"
  end
end