class AddBuyerApprovalStatusInItems < ActiveRecord::Migration[5.2]
  def change
  	add_column :items, :buyer_approved, :string, default: 'Pending'
  	add_column :items, :remarks, :text
  end
end