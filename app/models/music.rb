class Music < ActiveRecord::Base
  attr_accessible :anime_id, :name, :music, :image, :artist

  has_attached_file :music
  validates_attachment_content_type :music, :content_type => [ "audio/mpeg" ]

  belongs_to :oped
  belongs_to :anime
  process_in_background :music

  @@current_list = nil

  def self.random_song()
    if @@current_list == nil || @@current_list.empty? 
        @@current_list = Music.order("RAND()")
    end

    return @@current_list.pop
  end
end
