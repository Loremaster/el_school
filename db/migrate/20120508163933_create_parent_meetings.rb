class CreateParentMeetings < ActiveRecord::Migration
  def change
    create_table :parent_meetings do |t|
      t.integer :parent_id
      t.integer :meeting_id
      t.timestamps
    end
    
    add_index :parent_meetings, :parent_id
    add_index :parent_meetings, :meeting_id
  end
end
