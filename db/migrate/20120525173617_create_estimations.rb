class CreateEstimations < ActiveRecord::Migration
  def change
    create_table :estimations do |t|
      t.integer :reporting_id
      t.integer :pupil_id
      t.integer :nominal
      t.timestamps
    end
  end
end
