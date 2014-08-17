class Anime < ActiveRecord::Base
  searchable do
    text :name, :as => :name_textp
    text :synonyms, :as => :synonyms_textp
    integer :ranking
  end

  attr_accessible :name, :ranking
  
  def synonyms
    return Synonym.where(:anime_key => self.name).map{|ele| ele.name}.join(' ')
  end

  def synonym_objects
    return Synonym.where(:anime_key => self.name)
  end
end
