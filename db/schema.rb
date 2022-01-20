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

ActiveRecord::Schema.define(version: 2022_01_17_121046) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applications", force: :cascade do |t|
    t.string "token"
    t.string "name"
    t.integer "chats_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_applications_on_token"
  end

  create_table "chats", force: :cascade do |t|
    t.integer "number"
    t.integer "messages_count"
    t.bigint "application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_chats_on_application_id"
    t.index ["number"], name: "index_chats_on_number"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "number"
    t.string "content"
    t.bigint "chat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["number"], name: "index_messages_on_number"
  end

  add_foreign_key "chats", "applications"
  add_foreign_key "messages", "chats"
end
