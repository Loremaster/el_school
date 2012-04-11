class CreatePupils < ActiveRecord::Migration
  def change
    create_table :pupils do |t|
      t.integer :user_id
      t.integer :school_class_id
      t.string  :pupil_last_name
      t.string  :pupil_first_name
      t.string  :pupil_middle_name
      t.date    :pupil_birthday
      t.string  :pupil_sex
      t.string  :pupil_nationality
      t.string  :pupil_address_of_registration
      t.string  :pupil_address_of_living
      t.timestamps
    end
  end
end
