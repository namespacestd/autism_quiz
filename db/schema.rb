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

ActiveRecord::Schema.define(:version => 20141228190034) do

  create_table "animes", :force => true do |t|
    t.string  "name"
    t.integer "ranking"
  end

  create_table "musics", :force => true do |t|
    t.string   "name"
    t.integer  "anime_id"
    t.integer  "oped_id"
    t.string   "music_file_name"
    t.string   "music_content_type"
    t.integer  "music_file_size"
    t.datetime "music_updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "opeds", :force => true do |t|
    t.string "name"
    t.string "artist"
    t.string "anime_key"
  end

  create_table "scores", :force => true do |t|
    t.string  "username"
    t.string  "uuid"
    t.integer "score"
  end

  create_table "synonyms", :force => true do |t|
    t.string "name"
    t.string "anime_key"
  end

  create_table "test_tables", :force => true do |t|
  end

end
