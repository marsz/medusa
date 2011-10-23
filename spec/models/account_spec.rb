require 'spec_helper'

describe Account do
  it {should have_many(:spiders)}
  it {should validate_presence_of(:name)}
  it {
    Account.create!(:name=>:abc)
    should validate_uniqueness_of(:name)
  }
end
