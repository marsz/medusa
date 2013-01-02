class App < ActiveRecord::Base
  validates_uniqueness_of :token
  validates_uniqueness_of :name
  validates_presence_of :name

  before_create :generate_token

  def validate_domain(domains)
    return true if !limited_domains.present?
    return false if !domains.present?
    domains = [domains] if domains.is_a?(String)
    domains.each do |domain|
      domain = URI.parse(domain).host if domain.index("http") == 0
      return true if limited_domains.gsub(" ", "").split(",").include?(domain)
    end
    false
  end

  private 

  def generate_token
    self.token = Digest::MD5.hexdigest "#{SecureRandom.uuid}-#{DateTime.now.to_s}" if self.new_record?
  end

end
