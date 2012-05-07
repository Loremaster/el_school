class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :school_class_id
      t.integer :teacher_id
      t.string  :event_place
      t.string  :event_place_of_start
      t.date    :event_begin_date
      t.date    :event_end_date
      t.time    :event_begin_time
      t.time    :event_end_time
      t.integer :event_cost
      t.timestamps
    end
  end
end
