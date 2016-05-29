class Image < ActiveRecord::Base
  belongs_to :event

  # This method associates the attribute ":photo" with a file attachment
  has_attached_file :photo, styles: { medium: "300x300>", thumb: "100x100>" }
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

end
