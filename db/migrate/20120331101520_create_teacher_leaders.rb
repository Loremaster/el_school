class CreateTeacherLeaders < ActiveRecord::Migration
  def change
    create_table :teacher_leaders do |t|
      t.integer :user_id
      t.integer :teacher_id
      t.timestamps
    end
    
    add_index :teacher_leaders, :user_id
    add_index :teacher_leaders, :teacher_id
  end
end