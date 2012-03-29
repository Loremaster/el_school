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

ActiveRecord::Schema.define(:version => 20120329100404) do

  create_table "subjects", :force => true do |t|
    t.string   "subject_name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "teacher_educations", :force => true do |t|
    t.integer  "teacher_id"
    t.string   "teacher_education_university"
    t.date     "teacher_education_year"
    t.string   "teacher_education_graduation"
    t.string   "teacher_education_speciality"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "teacher_phones", :force => true do |t|
    t.integer  "teacher_id"
    t.string   "teacher_home_number"
    t.string   "teacher_mobile_number"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "teachers", :force => true do |t|
    t.integer  "user_id"
    t.string   "teacher_last_name"
    t.string   "teacher_first_name"
    t.string   "teacher_middle_name"
    t.date     "teacher_birthday"
    t.string   "teacher_sex"
    t.string   "teacher_category"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "user_login"
    t.string   "user_role"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "encrypted_password"
    t.string   "salt"
  end

end
