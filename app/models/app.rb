class App < ActiveRecord::Base
  validates_uniqueness_of :token
  validates_uniqueness_of :name
  validates_presence_of :name

  before_create :generate_token

  def validate_domain(domain)
    return true if !limited_domains.present?
    return false if !domain.present?
    domain = URI.parse(domain).host if domain.index("http") == 0
    limited_domains.gsub(" ", "").split(",").include?(domain)
  end

  private 

  def generate_token
    self.token = Digest::MD5.hexdigest "#{SecureRandom.uuid}-#{DateTime.now.to_s}" if self.new_record?
  end

end
