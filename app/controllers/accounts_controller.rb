class AccountsController < ApplicationController
  include ActAsGogolook
  
  before_filter :get_account
  
  def create
    @account = Account.new(params[:account])
    if @account.save
      respond @account 
    else
      render_error @account
    end
  end
  
  def update
    if @account.update_attributes(params[:account])
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
    
end
