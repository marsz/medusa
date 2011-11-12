class AccountsController < ApplicationController
  include ActAsImportable
  include ActAsGogolook
  before_filter :sync_spiders, :only => [:create, :update]
  before_filter :get_account
  def create
    @account = Account.new(params[:account])
    if @account.save
      @account.spiders = @spiders.map{|spider|
        spider.account = @account
        spider.save
        spider
      }
      respond @account 
    else
      render_error @account
    end
  end
  def update
    # @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      @spiders.each{|spider|
        spider.account = @account if !spider.id
        spider.save
      }
      respond @account 
    else
      render_error @account
    end
  end
  protected
  def get_account
    if params[:id]
      @account = Account.find_by_name(params[:id]) || Account.find(params[:id])
    end
  end
  def sync_spiders
    @spiders = params[:account][:spiders] rescue nil
    if @spiders 
      @spiders = params[:account][:spiders].map {|hash|
        spider = Spider.new(hash)
        spider.id = hash["id"] if hash["id"]
        spider
      }
      params[:account].delete(:spiders)
    else
      @spiders = []
    end
  end
end
