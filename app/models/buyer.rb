class Buyer < ApplicationRecord

	COMPANY = ['Eclat International', 'Banumathi Exports']
	EMAILS = ['merch@banumathiexports.com']

	has_many :couriers, dependent: :destroy
	has_many :teams, dependent: :destroy
	
	validates :name, {presence: true, uniqueness: {case_sensitive: true}, length: {minimum: 3, maximum: 75}}
	validates :address, {presence: true, length: {minimum: 3, maximum: 500}}

	after_save :add_buyer_to_admin

	def add_buyer_to_admin
		admin = User.first
		unless admin.buyer_ids.include?(self.id)
			admin.buyer_ids.push(self.id)
			admin.save
		end
	end

	def company_upcase
		company.upcase
	end

	def is_eclat
		company == COMPANY[0]
	end

end
