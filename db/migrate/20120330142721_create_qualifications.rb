class CreateQualifications < ActiveRecord::Migration
  def change
    create_table :qualifications do |t|
      t.integer :subject_id
      t.integer :teacher_id
      t.timestamps
    end
  end
end
