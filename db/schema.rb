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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140711122454) do

  create_table "chapters", force: true do |t|
    t.string   "file_name",       limit: 1024
    t.string   "url",             limit: 1024
    t.string   "title",           limit: 1024
    t.integer  "chapter_id"
    t.string   "chapter_no",      limit: 1024
    t.datetime "file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chapters", ["chapter_id"], name: "index_chapters_on_chapter_id"
  add_index "chapters", ["chapter_no"], name: "index_chapters_on_chapter_no", unique: true
  add_index "chapters", ["file_updated_at"], name: "index_chapters_on_file_updated_at"
  add_index "chapters", ["url"], name: "index_chapters_on_url", unique: true

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.integer  "chapter_id"
    t.string   "comment_dom"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["chapter_id", "comment_dom"], name: "index_comments_on_chapter_id_and_comment_dom"
  add_index "comments", ["chapter_id"], name: "index_comments_on_chapter_id"
  add_index "comments", ["comment_dom"], name: "index_comments_on_comment_dom"
  add_index "comments", ["comment_id"], name: "index_comments_on_comment_id"
  add_index "comments", ["user_id", "chapter_id", "comment_dom"], name: "index_comments_on_user_id_and_chapter_id_and_comment_dom"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "users", force: true do |t|
    t.string   "provider",            limit: 64
    t.string   "uid",                 limit: 64
    t.string   "name",                limit: 256
    t.string   "oauth_token",         limit: 256
    t.string   "image_url",           limit: 1024
    t.string   "email",               limit: 256
    t.datetime "oauth_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                            default: false
    t.boolean  "allow_notifications",              default: true
  end

  add_index "users", ["admin"], name: "index_users_on_admin"
  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["oauth_token"], name: "index_users_on_oauth_token"
  add_index "users", ["uid"], name: "index_users_on_uid"

end
