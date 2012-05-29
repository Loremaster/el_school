class CreateHomeworks < ActiveRecord::Migration
  def change
    create_table :homeworks do |t|
      t.integer :pupil_id
      t.integer :lesson_id
      t.string  :task_text
      t.timestamps
    end

    add_index :homeworks, :pupil_id
    add_index :homeworks, :lesson_id
  end
end
