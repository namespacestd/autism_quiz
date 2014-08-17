# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140816215421) do

  create_table "animes", :primary_key => "name", :force => true do |t|
    t.integer "ranking"
  end

  create_table "musics", :force => true do |t|
    t.string   "name"
    t.string   "artist"
    t.string   "anime"
    t.string   "music_file_file_name"
    t.string   "music_file_content_type"
    t.integer  "music_file_file_size"
    t.datetime "music_file_updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "synonyms", :id => false, :force => true do |t|
    t.string "name"
    t.string "anime_key"
  end

  add_index "synonyms", ["anime_key"], :name => "anime_key"

  create_table "test_tables", :force => true do |t|
  end

end
