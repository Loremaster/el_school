class CreatePupilsEvents < ActiveRecord::Migration
  def change
    create_table :pupils_events do |t|
      t.integer :pupil_id
      t.integer :event_id
      t.timestamps
    end

    add_index :pupils_events, :pupil_id
    add_index :pupils_events, :event_id
  end
end
