class CreateSchoolClasses < ActiveRecord::Migration
  def change
    create_table :school_classes do |t|
      t.integer :teacher_leader_id 
      t.string  :class_code
      t.date    :date_of_class_creation
      t.timestamps
    end
  end
end
