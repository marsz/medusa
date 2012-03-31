class CrawlerController < ApplicationController
  include ActAsAuthable
  act_as_authable
  
  def download
    render_by_format handle_by_action
  end
  
  def fetch
    render_by_format handle_by_action
  end
  
  protected
  def handle_by_action
    raise "missing parameter : url" unless params[:url]
    @options = params[:options] || {}
    spider = @options[:ip] ? Spider.find_by_ip_and_is_enabled(@options[:ip], true) : DomainCrawling.pick_spider(params[:url])
    if spider
      data = send "handle_#{params[:action]}", spider
      data[:spider] = {:id => spider.id, :ip => spider.ip}
      DomainCrawling.crawled(spider, params[:url])
    else
      raise "no spiders!"
    end
    AppCrawling.create!(:app => @app, :url => params[:url]) if @app && !@options[:disable_log]
    data
  end
  def handle_download spider
    spider.referer = params[:referer]
    if s = Storage.find_by_source_url(params[:url])
      url = s.url
      status = 304
    else
      url = spider.download(params[:url])
      status = spider.response_code
    end
    {:url => url, :status => status}
  end
  def handle_fetch spider
    data = spider.fetch(params[:url], params[:query], :encoding => @options[:encoding])
    data = spider.response_code unless spider.fetch_success?
    render_fetch data
  end
  def render_fetch data
    result = {
      :method=>request.method.downcase,
      :url=>params[:url],:query=>params[:query]
    }
    if data.is_a?(Fixnum)
      result[:status] = data
    else
      result[:data] = data
      result[:status] = 200
    end
    result
  end
  def render_by_format data
    respond_to do |f|
      f.html {render :text => data[:data].to_s}
      f.json {render :json => data.to_json}
      f.xml {render :xml => data.to_xml}
    end
  end
end
