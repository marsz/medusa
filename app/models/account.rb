class Account < ActiveRecord::Base
  
  serialize :connect_detail
  has_many :spiders
  
  validates_uniqueness_of :name
  validates_presence_of :name
end
