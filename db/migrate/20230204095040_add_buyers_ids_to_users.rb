class AddBuyersIdsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :buyer_ids, :text
  end
end
