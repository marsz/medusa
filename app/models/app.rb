class App < ActiveRecord::Base
  validates_uniqueness_of :token
  validates_uniqueness_of :name
  validates_presence_of :token
  validates_presence_of :name
end
