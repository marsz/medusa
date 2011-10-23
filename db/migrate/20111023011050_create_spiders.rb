class CreateSpiders < ActiveRecord::Migration
  def change
    create_table :spiders do |t|
      t.string :ip
      t.integer :port
      t.string :connect_type
      t.integer :account_id
      t.boolean :is_enabled
      t.datetime :last_validated_at
      t.timestamps
    end
    add_index :spiders, :ip, :unique=>true
  end
end
