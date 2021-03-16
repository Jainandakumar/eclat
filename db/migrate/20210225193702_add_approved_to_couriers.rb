class AddApprovedToCouriers < ActiveRecord::Migration[5.2]
  def change
    add_column :couriers, :approved, :boolean, default: false
  end
end
