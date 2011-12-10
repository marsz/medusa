class CrawlerController < ApplicationController
  include ActAsAuthable
  act_as_authable
  
  def fetch
    raise "missing parameter : url" if !params[:url]
    options = params[:options] || {}
    data = DomainCrawling.crawling(params[:url], params[:query], options.merge(:method=>request.method.downcase))
    if @app && !options[:disable_log]
      log_crawling(@app, params[:url])
    end
    render_output data
  end
  
  protected
  
  def log_crawling app, url
    AppCrawling.create!(:app => app, :url => url)
  end
  
  def render_output data, options = {}
    result = {
      :options => options,:method=>request.method.downcase,
      :url=>params[:url],:query=>params[:query],:data => data
    }
    respond_to do |f|
      f.html {render :text => result[:data].to_s}
      f.json {render :json => result.to_json}
      f.xml {render :xml => result.to_xml}
    end
  end
  
end
