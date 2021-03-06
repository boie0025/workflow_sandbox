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

ActiveRecord::Schema.define(version: 20150908201026) do

  create_table "background_job_groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "expires_at"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "arguments"
  end

  create_table "background_job_members", force: :cascade do |t|
    t.integer  "background_job_group_id"
    t.string   "name"
    t.datetime "expires_at"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "background_job_members", ["background_job_group_id"], name: "index_background_job_members_on_background_job_group_id"

  create_table "fusion_workflows", force: :cascade do |t|
    t.string   "workflow_state",   limit: 255
    t.string   "type",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "brand_id"
    t.integer  "medium_id"
    t.text     "meta"
    t.date     "fulfillment_date"
  end

end
