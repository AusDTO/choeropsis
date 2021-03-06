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

ActiveRecord::Schema.define(version: 20161005042206) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "batches", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "environment"
    t.string   "page_name"
    t.string   "url"
    t.string   "bs_job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "project_id"
    t.string  "target"
    t.string  "webhook_url"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "repo"
    t.string "github_user"
    t.string "basic_auth"
  end

  create_table "snaps", force: :cascade do |t|
    t.integer "batch_id"
    t.jsonb   "bs_platform_atts"
    t.string  "thumb_url"
    t.string  "image_url"
  end

end
