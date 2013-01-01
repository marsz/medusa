class AddColumnLimitedDomainsToApps < ActiveRecord::Migration
  def change
    add_column :apps, :limited_domains, :string, :after => :token
  end
end
