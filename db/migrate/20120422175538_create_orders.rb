class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer  :pupil_id
      t.integer  :school_class_id
      t.string   :number_of_order
      t.date     :date_of_order
      t.text     :text_of_order, :limit => nil      
      t.timestamps
    end
  end
end
