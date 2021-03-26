class Courier < ApplicationRecord

	belongs_to :buyer
	belongs_to :team
	has_many :items, dependent: :destroy
	has_one_attached :airway_bill_image

	validates :airway_bill_number, {presence: true, uniqueness: {case_sensitive: true}, length: {minimum: 3, maximum: 75}}
	validates :courier_date, presence: true

	def team_name
		team.present? ? team.name : '-'
	end

	def self.sent
		where.not(courier_date: nil)
	end

	def self.pending_delivery
		where(approved: true, delivery_date: nil)
	end

	def self.delivered
		where.not(delivery_date: nil)
	end

	def self.buyer_delivered buyer
		delivered.where(buyer_id: buyer.id)
	end

end
