class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :serial_number
      t.text :description
      t.integer :sample_type_id
      t.integer :courier_id

      t.timestamps
    end
  end
end
