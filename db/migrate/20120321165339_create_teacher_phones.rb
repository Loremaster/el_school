class CreateTeacherPhones < ActiveRecord::Migration
  def change
    create_table :teacher_phones do |t|
      t.integer :teacher_id
      t.string  :teacher_home_number
      t.string  :teacher_mobile_number
      t.timestamps
    end
  end
end
