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

	def self.sent user
		where.not(courier_date: nil).where(buyer_id: user.buyer_ids)
	end

	def self.pending_delivery user
		where(approved: true, delivery_date: nil, buyer_id: user.buyer_ids)
	end

	def self.delivered user
		where.not(delivery_date: nil).where(buyer_id: user.buyer_ids)
	end

	def self.buyer_delivered buyer, user
		delivered(user).where(buyer_id: buyer.id)
	end

end
