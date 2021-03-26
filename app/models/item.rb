class Item < ApplicationRecord

	belongs_to :sample_type
	belongs_to :courier
	has_one_attached :item_image

	def sample_type_name
		sample_type.present? ? sample_type.name : '-'
	end

	def self.delivered
		where(courier_id: Courier.delivered.ids)
	end

	def self.pending_buyer_comments
		where(buyer_approved: '', courier_id: Courier.delivered.ids)
	end

	def self.approved
		where(buyer_approved: 'Approved')
	end

	def self.pending
		where(buyer_approved: 'Pending')
	end
end
