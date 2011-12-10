require 'spec_helper'

describe "included classes" do
  
  include DataMaker
  before do
    @connect_type = :proxy
    making_for_real_fetch :connect_type => @connect_type
  end
  
  it_should_behave_like "fetch_by_connect_type"
  
end