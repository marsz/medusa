class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :user
      t.string :secret
      t.string :host
      t.integer :port
      t.text :connect_data
      t.timestamps
    end
  end
end
