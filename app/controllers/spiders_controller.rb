class SpidersController < ApplicationController
  
  include ActAsBelongsAccountController
  act_as_belongs_account_controller
  
  def validate
    @spiders = []
    @account.spiders.each do |spider|
      spider.validate
      @spiders << spider
    end
    respond @spiders
  end
  
  def create
    @spider = @account.spiders.build(params[:spider])
    if @spider.save
      respond @spider
    else
      render_error @spider
    end
  end
  
  def update
    @spider = @account.spiders.find(params[:id])
    if @spider.update_attributes(params[:spider])
      respond @spider
    else
      render_error @spider
    end
  end
  
  def destroy
    @spider = @account.spiders.find(params[:id])
    respond @spider.destroy
  end
    
end
