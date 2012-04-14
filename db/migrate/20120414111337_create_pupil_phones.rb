class CreatePupilPhones < ActiveRecord::Migration
  def change
    create_table :pupil_phones do |t|
      t.integer :pupil_id
      t.string  :pupil_home_number
      t.string  :pupil_mobile_number
      t.timestamps
    end
  end
end
