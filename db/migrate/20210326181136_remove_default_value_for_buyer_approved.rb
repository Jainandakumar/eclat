class RemoveDefaultValueForBuyerApproved < ActiveRecord::Migration[5.2]
  def change
	  change_column_default( :items, :buyer_approved, from: 'Pending', to: '' )
	end
end
