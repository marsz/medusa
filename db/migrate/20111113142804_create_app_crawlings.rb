class CreateAppCrawlings < ActiveRecord::Migration
  def change
    create_table :app_crawlings do |t|
      t.integer :app_id
      t.text :url
      t.string :domain
      t.timestamps
    end
  end
end
