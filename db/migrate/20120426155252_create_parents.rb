class CreateParents < ActiveRecord::Migration
  def change
    create_table :parents do |t|
      t.integer :user_id
      t.string  :parent_last_name
      t.string  :parent_first_name
      t.string  :parent_middle_name
      t.date    :parent_birthday
      t.string  :parent_sex      
      t.timestamps
    end
  end
end
