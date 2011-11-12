module ActAsGogolook
  extend ActiveSupport::Concern
  module InstanceMethods
    def refresh_ip_list
      if @account.name == "gogolook-proxybananza" && @account.id > 0
        Spider.where(:account_id => @account.id).each do |spider|
          spider.destroy
        end
        url = "http://gogolook-whoscalling.appspot.com/public/proxyiplist?api_key=iLck9Yc3e2XXia"
        RestClient.proxy = nil
        ActiveSupport::JSON.decode(RestClient.get(url))["ips"].each do |hash|
          ip = hash["ip"]
          spider = {:ip=>ip,:is_enabled=>true,:connect_type=>:proxy, :account => @account}
          Spider.create(spider)
        end
        @spiders = Spider.where(:account_id => @account.id).all
        render :json => @spiders.to_json
      end
    end
  end
  module ClassMethods
  end
end