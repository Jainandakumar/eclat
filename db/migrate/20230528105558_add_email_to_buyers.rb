class AddEmailToBuyers < ActiveRecord::Migration[6.1]
  def change
    add_column :buyers, :email, :string, default: 'merch@banumathiexports.com'
  end
end
