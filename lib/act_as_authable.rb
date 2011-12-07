module ActAsAuthable
  extend ActiveSupport::Concern
  module ClassMethods
    def act_as_authable
      before_filter :authenticate_app, :only=>[:fetch]
    end
  end
  module InstanceMethods
    def authenticate_app
      if @app = authenticating(params[:token])
      else
        render :status => 500, :text => "token fail"
      end
    end
    protected
    def log_crawling app, url
      AppCrawling.create!(:app => app, :url => url)
    end
    def authenticating token
      app = nil
      if !token.blank?
        app = App.find_by_token(params[:token])
      end
      app
    end
  end
end