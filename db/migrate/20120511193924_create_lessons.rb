class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.integer :timetable_id
      t.date    :lesson_date
      t.timestamps
    end

    add_index :lessons, :timetable_id
  end
end
