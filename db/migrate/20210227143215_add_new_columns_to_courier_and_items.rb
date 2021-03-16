class AddNewColumnsToCourierAndItems < ActiveRecord::Migration[5.2]
  def change
  	add_column :couriers, :delivery_date, :date
  	add_column :couriers, :number_of_items, :integer, default: 0
  	add_column :items, :received_status, :boolean, default: false
  	add_column :items, :buyer_comments, :text
  	add_column :items, :number_of_samples, :integer, default: 0
  end
end
