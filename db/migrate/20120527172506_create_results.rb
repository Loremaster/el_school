class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :pupil_id
      t.integer :curriculum_id
      t.integer :quarter_1
      t.integer :quarter_2
      t.integer :quarter_3
      t.integer :quarter_4
      t.integer :year
      t.timestamps
    end

    add_index :results, :pupil_id
    add_index :results, :curriculum_id
  end
end
