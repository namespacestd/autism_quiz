class CreateAnimeTable < ActiveRecord::Migration
  def up
    create_table :animes do |t|
        t.string :name
        t.integer :ranking
        t.string :image_link
    end

    create_table :synonyms do |t|
        t.string :name
        t.string :anime_key
    end

    create_table :musics do |t|
        t.string :name
        t.integer :anime_id
        t.integer :oped_id
    end

    create_table :opeds do |t|
        t.string :name
        t.string :artist
        t.string :anime_key

    end

    add_attachment :musics, :music
    add_attachment :animes, :image
  end

  def down
    remove_attachment :musics, :music
    remove_attachment :animes, :image
  end
end
