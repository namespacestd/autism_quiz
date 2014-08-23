class Music < ActiveRecord::Base
  attr_accessible :anime, :name, :music_file, :music_file_name, :image, :artist

  has_attached_file :music_file
  has_attached_file :image
  validates_attachment_content_type :music_file, :content_type => [ "audio/mpeg" ]
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  @@current_list = nil

  def self.random_song()
    if @@current_list == nil || @@current_list.empty? 
        @@current_list = Music.order("RAND()")
    end

    return @@current_list.pop
  end
end
