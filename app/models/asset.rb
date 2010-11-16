class Asset < ActiveRecord::Base
  belongs_to :user
  has_many :asset_documents,:dependent => :destroy
  has_attached_file :attachment, :path=>":rails_root/public/attachments/:id/:styles.:basename.:extension",
                    :url => "/attachments/:id/:styles.:basename.:extension"
  validates_attachment_presence :attachment
  validates_attachment_content_type :attachment,
                                    :content_type => ['application/vnd.ms-powerpoint', 'application/vnd.ms-excel', 'application/msword', 'application/vnd.oasis.opendocument.text','application/rtf','text/html']
  TEXT_FORMAT = %w(pdf odt sxw rtf  doc txt html wiki)
  XL_FORMAT = %w(pdf ods sxc xls csv tsv html)
  PT_FORMAT = %w(pdf swf odp sxi ppt html)
  ODG_FORMAT = %w(svg swf)
  VALID_FORMAT=	{
      "odt"=>TEXT_FORMAT,
      "sxw"=>TEXT_FORMAT,
      "rtf"=>TEXT_FORMAT,
      "doc"=>TEXT_FORMAT,
      "wpd"=>TEXT_FORMAT,
      "txt"=>TEXT_FORMAT,
      "html"=>TEXT_FORMAT,
      "htm"=>TEXT_FORMAT,
      "ods"=>XL_FORMAT,
      "sxc"=>XL_FORMAT,
      "xls"=>XL_FORMAT,
      "csv"=>XL_FORMAT,
      "tsv"=>XL_FORMAT,
      "odp"=>PT_FORMAT,
      "sxi"=>PT_FORMAT,
      "ppt"=>PT_FORMAT,
      "odg"=>ODG_FORMAT
  }
  def list_valid_formats

    file_ext_name = File.extname(self.attachment_file_name).split(".").last
    if VALID_FORMAT.keys.include?(file_ext_name)
      VALID_FORMAT[file_ext_name]
    else
      []
    end
  end

  def start_conversion(format)
    src_file = self.attachment.path
    dest_file= self.attachment.path+"."+format
     ConvertOffice::ConvertOfficeFormat.new.convert(src_file,dest_file)
    [self.attachment_file_name+"."+format,self.attachment.url.split("?").first+"."+format]
  end
end
