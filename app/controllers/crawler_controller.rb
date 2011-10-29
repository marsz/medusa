class CrawlerController < ApplicationController
  def fetch
    if params[:url]
      params[:options] ||= {}
      params[:options][:method] = request.method.downcase      
      result = {:method => params[:options][:method],:url => params[:url]}
      result[:data] = DomainCrawling.crawling(params[:url], params[:query], params[:options])
      respond_to do |f|
        f.html {render :text => result[:data].to_s}
        f.json {render :json => result.to_json}
        f.xml {render :xml => result.to_xml}
      end
    else
      render :status => 500, :text => "missing parameter : url"
    end
  end
end
