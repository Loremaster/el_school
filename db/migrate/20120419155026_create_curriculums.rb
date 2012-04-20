class CreateCurriculums < ActiveRecord::Migration
  def change
    create_table :curriculums do |t|
      t.integer :school_class_id
      t.integer :qualification_id    
      t.timestamps
    end
  end
end
