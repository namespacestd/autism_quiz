class Music < ActiveRecord::Base
  attr_accessible :anime, :name, :music_file, :music_file_name

  has_attached_file :music_file
  validates_attachment_content_type :music_file, :content_type => [ "audio/mpeg" ]

  def self.random_song()
    all_music = Music.all
    return all_music[rand(all_music.length)]
  end
end
