class AssetDocument < ActiveRecord::Base
  belongs_to :asset
  before_destroy :delete_necessary_document

  def delete_necessary_document
    if File.exist?("#{Rails.root}+/public+#{self.path}")
      FileUtils.rm("#{Rails.root}+/public+#{self.path}")
    end
  end
end
