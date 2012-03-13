class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.integer :user_id
      t.string  :teacher_last_name
      t.string  :teacher_first_name
      t.string  :teacher_middle_name
      t.date    :teacher_birthday
      t.string  :teacher_sex
      t.string  :teacher_category
      t.timestamps
    end
  end
end
