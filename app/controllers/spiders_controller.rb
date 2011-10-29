class SpidersController < ApplicationController
  include ActAsImportable
  before_filter :get_account
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
    @account = Account.find(params[:account_id])
  end
end
