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

ActiveRecord::Schema.define(:version => 20120606130235) do

  create_table "attendances", :force => true do |t|
    t.integer  "pupil_id"
    t.integer  "lesson_id"
    t.boolean  "visited"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "attendances", ["lesson_id"], :name => "index_attendances_on_lesson_id"
  add_index "attendances", ["pupil_id"], :name => "index_attendances_on_pupil_id"

  create_table "curriculums", :force => true do |t|
    t.integer  "school_class_id"
    t.integer  "qualification_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "estimations", :force => true do |t|
    t.integer  "reporting_id"
    t.integer  "pupil_id"
    t.integer  "nominal"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "school_class_id"
    t.integer  "teacher_id"
    t.string   "event_place"
    t.string   "event_place_of_start"
    t.date     "event_begin_date"
    t.date     "event_end_date"
    t.time     "event_begin_time"
    t.time     "event_end_time"
    t.integer  "event_cost"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "description"
  end

  create_table "homeworks", :force => true do |t|
    t.integer  "school_class_id"
    t.integer  "lesson_id"
    t.string   "task_text"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "homeworks", ["lesson_id"], :name => "index_homeworks_on_lesson_id"
  add_index "homeworks", ["school_class_id"], :name => "index_homeworks_on_school_class_id"

  create_table "lessons", :force => true do |t|
    t.integer  "timetable_id"
    t.date     "lesson_date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "lessons", ["timetable_id"], :name => "index_lessons_on_timetable_id"

  create_table "meetings", :force => true do |t|
    t.integer  "school_class_id"
    t.string   "meeting_theme"
    t.date     "meeting_date"
    t.time     "meeting_time"
    t.string   "meeting_room"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "pupil_id"
    t.integer  "school_class_id"
    t.string   "number_of_order"
    t.date     "date_of_order"
    t.text     "text_of_order"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "parent_meetings", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "meeting_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "parent_meetings", ["meeting_id"], :name => "index_parent_meetings_on_meeting_id"
  add_index "parent_meetings", ["parent_id"], :name => "index_parent_meetings_on_parent_id"

  create_table "parent_pupils", :force => true do |t|
    t.integer  "pupil_id"
    t.integer  "parent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "parent_pupils", ["parent_id"], :name => "index_parent_pupils_on_parent_id"
  add_index "parent_pupils", ["pupil_id"], :name => "index_parent_pupils_on_pupil_id"

  create_table "parents", :force => true do |t|
    t.integer  "user_id"
    t.string   "parent_last_name"
    t.string   "parent_first_name"
    t.string   "parent_middle_name"
    t.date     "parent_birthday"
    t.string   "parent_sex"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "pupil_phones", :force => true do |t|
    t.integer  "pupil_id"
    t.string   "pupil_home_number"
    t.string   "pupil_mobile_number"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "pupils", :force => true do |t|
    t.integer  "user_id"
    t.integer  "school_class_id"
    t.string   "pupil_last_name"
    t.string   "pupil_first_name"
    t.string   "pupil_middle_name"
    t.date     "pupil_birthday"
    t.string   "pupil_sex"
    t.string   "pupil_nationality"
    t.string   "pupil_address_of_registration"
    t.string   "pupil_address_of_living"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "pupils_events", :force => true do |t|
    t.integer  "pupil_id"
    t.integer  "event_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "pupils_events", ["event_id"], :name => "index_pupils_events_on_event_id"
  add_index "pupils_events", ["pupil_id"], :name => "index_pupils_events_on_pupil_id"

  create_table "qualifications", :force => true do |t|
    t.integer  "subject_id"
    t.integer  "teacher_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reportings", :force => true do |t|
    t.string   "report_type"
    t.string   "report_topic"
    t.integer  "lesson_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "reportings", ["lesson_id"], :name => "index_reportings_on_lesson_id"

  create_table "results", :force => true do |t|
    t.integer  "pupil_id"
    t.integer  "curriculum_id"
    t.integer  "quarter_1"
    t.integer  "quarter_2"
    t.integer  "quarter_3"
    t.integer  "quarter_4"
    t.integer  "year"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "results", ["curriculum_id"], :name => "index_results_on_curriculum_id"
  add_index "results", ["pupil_id"], :name => "index_results_on_pupil_id"

  create_table "school_classes", :force => true do |t|
    t.integer  "teacher_leader_id"
    t.string   "class_code"
    t.date     "date_of_class_creation"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

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

  create_table "teacher_leaders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "teacher_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "teacher_leaders", ["teacher_id"], :name => "index_teacher_leaders_on_teacher_id"
  add_index "teacher_leaders", ["user_id"], :name => "index_teacher_leaders_on_user_id"

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

  create_table "timetables", :force => true do |t|
    t.integer  "curriculum_id"
    t.integer  "school_class_id"
    t.string   "tt_day_of_week"
    t.integer  "tt_number_of_lesson"
    t.string   "tt_room"
    t.string   "tt_type"
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
