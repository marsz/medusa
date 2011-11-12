module ActAsValidatable
  extend ActiveSupport::Concern
  
  module ClassMethods
  end
  module InstanceMethods
    def validate options = {}
      url = options[:url] || "http://www.bing.com/"
      begin
        is_enabled = !self.fetch(url).blank?
      rescue
        is_enabled = false
      end
      self.update_attributes(:is_enabled => is_enabled, :last_validated_at => Time.now)
    end
  end
end