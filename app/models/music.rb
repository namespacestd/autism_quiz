class Music < ActiveRecord::Base
  attr_accessible :anime, :name, :music_file, :music_file_name, :image, :artist

  has_attached_file :music_file
  has_attached_file :image
  validates_attachment_content_type :music_file, :content_type => [ "audio/mpeg" ]
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def self.random_song() 
    return Music.order("RAND()").first
  end
end
