class CreateTimetables < ActiveRecord::Migration
  def change
    create_table :timetables do |t|
      t.integer :curriculum_id
      t.integer :school_class_id
      t.string  :tt_day_of_week
      t.integer :tt_number_of_lesson
      t.string  :tt_room
      t.string  :tt_type
      t.timestamps
    end
  end
end
