class CreateDomainCrawlings < ActiveRecord::Migration
  def change
    create_table :domain_crawlings do |t|
      t.string :domain
      t.integer :spider_id
      t.datetime :crawled_at
      t.timestamps
    end
    add_index :domain_crawlings, [:domain,:spider_id], :unique => true
    add_index :domain_crawlings, :spider_id
  end
end
