class CreateParentPupils < ActiveRecord::Migration
  def change
    create_table :parent_pupils do |t|
      t.integer :pupil_id
      t.integer :parent_id
      t.timestamps
    end
    
    add_index :parent_pupils, :pupil_id
    add_index :parent_pupils, :parent_id
  end
end
