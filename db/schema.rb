# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120218081528) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "user"
    t.string   "secret"
    t.string   "host"
    t.integer  "port"
    t.text     "connect_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_crawlings", :force => true do |t|
    t.integer  "app_id"
    t.text     "url"
    t.string   "domain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apps", :force => true do |t|
    t.string   "token"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "domain_crawlings", :force => true do |t|
    t.string   "domain"
    t.integer  "spider_id"
    t.datetime "crawled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "domain_crawlings", ["domain", "spider_id"], :name => "index_domain_crawlings_on_domain_and_spider_id", :unique => true
  add_index "domain_crawlings", ["spider_id"], :name => "index_domain_crawlings_on_spider_id"

  create_table "spiders", :force => true do |t|
    t.string   "ip"
    t.integer  "port"
    t.string   "connect_type"
    t.integer  "account_id"
    t.boolean  "is_enabled"
    t.datetime "last_validated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spiders", ["account_id"], :name => "index_spiders_on_account_id"
  add_index "spiders", ["connect_type"], :name => "index_spiders_on_connect_type"
  add_index "spiders", ["ip"], :name => "index_spiders_on_ip", :unique => true
  add_index "spiders", ["is_enabled"], :name => "index_spiders_on_is_enabled"

  create_table "storages", :force => true do |t|
    t.string   "source_url"
    t.string   "url"
    t.integer  "spider_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "storages", ["source_url"], :name => "index_storages_on_source_url", :unique => true
  add_index "storages", ["spider_id"], :name => "index_storages_on_spider_id"

end
