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

ActiveRecord::Schema.define(version: 20160930043315) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "batch", force: :cascade do |t|
    t.integer  "environment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "environments", force: :cascade do |t|
    t.integer "project_id"
    t.string  "name"
    t.string  "domain"
  end

  create_table "pages", force: :cascade do |t|
    t.integer "project_id"
    t.string  "path"
    t.boolean "ssl",        default: false, null: false
  end

  create_table "platforms", force: :cascade do |t|
    t.integer "project_id"
    t.string  "os"
    t.string  "os_version"
    t.string  "browser"
    t.string  "browser_version"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
  end

  create_table "snap", force: :cascade do |t|
    t.integer "batch_id"
    t.integer "page_id"
    t.string  "thumb_url"
    t.string  "image_url"
  end

end
