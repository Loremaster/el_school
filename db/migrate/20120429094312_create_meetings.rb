class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.integer :school_class_id
      t.string  :meeting_theme
      t.date    :meeting_date
      t.time    :meeting_time
      t.string  :meeting_room      
      t.timestamps
    end
  end
end
