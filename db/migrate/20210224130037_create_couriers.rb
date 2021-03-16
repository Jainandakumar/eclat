class CreateCouriers < ActiveRecord::Migration[5.0]
  def change
    create_table :couriers do |t|
      t.string :airway_bill_number
      t.text :buyer_comments
      t.integer :buyer_id
      t.date :courier_date
      t.text :description
      t.boolean :received_status, default: false
      t.integer :team_id
      t.timestamps
    end
  end
end
