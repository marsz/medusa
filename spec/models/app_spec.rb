require 'spec_helper'

describe App do
  include DataMaker
  before do
    making_for_real_fetch
  end
  it {should validate_presence_of(:name)}
  it {should validate_uniqueness_of(:token)}
  it {should validate_uniqueness_of(:name)}

  describe "#validate_domain" do
    it "specify" do
      app = FactoryGirl.create :app, :limited_domains => "foo.com, bar.com"
      app.validate_domain("localhost/bar.com").should be_false
      app.validate_domain("http://localhost/asd/foo.com").should be_false
      app.validate_domain("foo.com").should be_true
      app.validate_domain("http://foo.com/asds/asdasd").should be_true
      app.validate_domain("bar.com").should be_true
      app.validate_domain("http://bar.com/asds/asdasd").should be_true
    end
    it "for all" do
      app = FactoryGirl.create :app, :limited_domains => nil
      app.validate_domain("localhost").should be_true
      app.validate_domain("http://localhost/asd").should be_true
    end
  end

end
