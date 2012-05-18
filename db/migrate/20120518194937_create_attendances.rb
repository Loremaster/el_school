class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :pupil_id
      t.integer :lesson_id
      t.timestamps
    end

    add_index :attendances, :pupil_id
    add_index :attendances, :lesson_id
  end
end
