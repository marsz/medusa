class Storage < ActiveRecord::Base
  validates_presence_of :source_url
  validates_presence_of :spider_id
  validates_uniqueness_of :source_url
  belongs_to :spider

  def self.create_by_source_url_and_spider(source_url, spider)
    unless s = Storage.find_by_source_url(source_url)
      s = Storage.new(:spider => spider, :source_url => source_url)
      s.save
    end
    s
  end
  def upload tmp_file_path
    return update_attributes(:url => tmp_file_path) if Rails.env == "test"
    file_name = Pathname.new(tmp_file_path).basename.to_s
    key = "storages/#{id}/#{file_name}"
    tmp_file = File.open(tmp_file_path)
    file = $fog.files.create(:key => key, :public => true, :body => tmp_file)
    tmp_file.close
    update_attributes(:url => file.public_url) ? url : nil
  end
end
