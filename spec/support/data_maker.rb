module DataMaker
  def making_for_real_fetch
    @account = Factory(:account)
    @spider = Factory(:spider, :account=>@account)
    @app = Factory(:app)
  end
end