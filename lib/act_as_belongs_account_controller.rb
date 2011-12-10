module ActAsBelongsAccountController
  extend ActiveSupport::Concern
  
  module ClassMethods
    
    def act_as_belongs_account_controller
      before_filter :get_account
    end
    
  end
  
  module InstanceMethods
    
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
  
end