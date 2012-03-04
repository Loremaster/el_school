class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_login
      t.string :user_role

      t.timestamps
    end
  end
end
