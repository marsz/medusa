module ActAsDomainParsable
  extend ActiveSupport::Concern
  
  module ClassMethods
    def parse_domain(url)
      tmp = (url.to_s.index("http") != 0) ? "http://#{url}" : url
      tmp = Domainatrix.parse(tmp) rescue nil
      return tmp ? tmp.domain.downcase : url
    end
  end
  
  module InstanceMethods
    def parse_domain(url)
      self.class.parse_domain(url)
    end
  end
end