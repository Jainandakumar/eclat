class AddCompanyToBuyers < ActiveRecord::Migration[5.2]
  def change
  	add_column :buyers, :company, :string, default: 'Eclat International'
  end
end
