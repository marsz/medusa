require 'spec_helper'

describe App do
  include DataMaker
  before do
    making_for_real_fetch
  end
  it {should validate_presence_of(:token)}
  it {should validate_presence_of(:name)}
  it {should validate_uniqueness_of(:token)}
  it {should validate_uniqueness_of(:name)}
end
