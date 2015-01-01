class Anime < ActiveRecord::Base
  searchable do
    text :name, :as => :name_textp, :boost => 3.0
    text :synonyms, :as => :synonyms_textp
    text :characters, :as => :characters_textp
    integer :ranking
  end

  attr_accessible :name, :ranking, :image_link, :image_file_name

  has_attached_file :image
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  process_in_background :image

  def characters
    chars = self.name.chars.to_a
    chars.delete("")
    return chars.join("")
  end
  
  def synonyms
    return Synonym.where(:anime_key => self.name).map{|ele| ele.name}.join(' ')
  end

  def synonym_objects
    return Synonym.where(:anime_key => self.name)
  end

  def save_new_entry(target_oped, url)
      mp3_link = ""

      if self.image_file_name.nil?
        self.image = open(self.image_link)
        self.save()
      end

      while mp3_link == ""
        Timeout::timeout(5000) {
          mp3_link = `casperjs convert_youtube_to_mp3.js --url="#{url}"`
        }
      end

      music_entry = Music.new
      music_entry.music = open(mp3_link)
      music_entry.anime_id = self.id
      music_entry.oped_id = target_oped.id
      music_entry.save()
  end
end
