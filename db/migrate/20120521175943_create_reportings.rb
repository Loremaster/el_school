class CreateReportings < ActiveRecord::Migration
  def change
    create_table :reportings do |t|
      t.string :report_type
      t.string :report_topic
      t.integer :lesson_id
      t.timestamps
    end

    add_index :reportings, :lesson_id
  end
end
