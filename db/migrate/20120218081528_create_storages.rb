class CreateStorages < ActiveRecord::Migration
  def change
    create_table :storages do |t|
      t.string :source_url
      t.string :url
      t.integer :spider_id
      t.timestamps
    end
    add_index :storages, :source_url, :unique => true
    add_index :storages, :spider_id
  end
end
