class SpidersController < ApplicationController
  include ActAsImportable
  before_filter :get_account
  def validate
    @spiders = []
    Spider.where(:account_id => @account.id).each do |spider|
      spider.validate
      @spiders << spider
    end
    respond_to do |f|
      f.html { render :text => @spiders.to_json}
      f.json { render :json => @spiders.to_json}
      f.xml { render :xml => @spiders.to_xml}
    end
  end
  def destroy
    @spider = Spider.find(params[:id])
    render :text => @spider.destroy.to_s
  end
  def create
    @spider = Spider.new(params[:spider])
    @spider.account = @account
    if @spider.save
      respond @spider
    else
      render_error @spider
    end
  end
  def update
    @spider = Spider.find(params[:id])
    if @spider.account_id != @account.id
      render :status => 500, :text => "account id error"
    elsif @spider.update_attributes(params[:spider])
      respond @spider
    else
      render_error @spider
    end
  end
  protected
  def get_account
    if params[:account_id].to_i > 0
      @account = Account.find(params[:account_id])
    else
      @account = Account.find_by_name(params[:account_id])
      if !@account
        render :status => 404, :text => "'#{params[:account_id]}' not found"
      end
    end
  end
end
