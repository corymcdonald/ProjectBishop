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

ActiveRecord::Schema.define(version: 20141122224304) do

  create_table "classes_lists", force: true do |t|
    t.string   "user"
    t.string   "course"
    t.string   "grade"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: true do |t|
    t.string   "title"
    t.string   "name"
    t.string   "coreRequirement"
    t.text     "description"
    t.text     "coreqDesc"
    t.text     "coreqData"
    t.text     "prereqDesc"
    t.text     "prereqData"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "majors", force: true do |t|
    t.string   "major"
    t.string   "course"
    t.string   "year"
    t.string   "semester"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", force: true do |t|
    t.string  "status"
    t.string  "name"
    t.string  "section"
    t.string  "courseID"
    t.string  "title"
    t.string  "component"
    t.string  "session"
    t.string  "hour"
    t.integer "classNumber"
    t.time    "startDate"
    t.time    "endDate"
    t.string  "classTime"
    t.string  "location"
    t.string  "instructor"
    t.string  "enrolled"
    t.string  "size"
    t.string  "career"
    t.string  "school"
    t.string  "department"
    t.string  "campus"
  end

  create_table "users", force: true do |t|
    t.string   "firstName"
    t.string   "lastName"
    t.string   "email"
    t.string   "major"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
