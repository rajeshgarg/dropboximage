class Image < ActiveRecord::Base
 # self.table_name = "images"
  SPORTS = ['Football','Cricket','Field Hockey','Tennis','Volleyball','Table Tennis','Baseball','Golf','American Football']

  acts_as_gmappable process_geocoding: false

  validates_inclusion_of :sport, :in => Image::SPORTS
  validates_presence_of :name
  has_attached_file :picture,
  :storage => :dropbox,
  :dropbox_credentials => "#{Rails.root}/config/dropbox.yml",
  :styles => { :medium => "300x300" , :thumb => "100x100>"},    
  :dropbox_options => {       
  :path => proc { |style| "#{style}/#{id}_#{picture.original_filename}"},       :unique_filename => true   
  }
 geocoded_by :address, :latitude => :latitude, :longitude => :longitude

validates_attachment_content_type :picture, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

validates :picture, :attachment_presence => true 
  # *** Server-side reverse geocoding, not for this example!
  #reverse_geocoded_by :latitude, :longitude do |obj,results|
  #  if geo = results.first
  #    obj.city    = geo.city
  #    obj.postal_code = geo.postal_code
  #    obj.country = geo.country_code
  #    obj.route = geo.address
  #  end
  #end
    
  #after_validation :reverse_geocode  

  #def address=(address)
  #end
    
end
