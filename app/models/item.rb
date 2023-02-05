class Item < ApplicationRecord

	belongs_to :sample_type
	belongs_to :courier
	has_one_attached :item_image

	def sample_type_name
		sample_type.present? ? sample_type.name : '-'
	end

	def self.sent user
		where(courier_id: Courier.where(buyer_id: user.buyer_ids).ids)
	end

	def self.delivered user
		where(courier_id: Courier.delivered(user).ids)
	end

	def self.pending_buyer_comments user
		where(buyer_approved: '', courier_id: Courier.delivered(user).ids)
	end

	def self.approved user
		where(buyer_approved: 'Approved', courier_id: Courier.where(buyer_id: user.buyer_ids).ids)
	end

	def self.pending user
		where(buyer_approved: 'Pending', courier_id: Courier.where(buyer_id: user.buyer_ids).ids)
	end

	def self.pending_buyer_comments_with_buyer buyer, user
		where(buyer_approved: '', courier_id: Courier.buyer_delivered(buyer, user).ids)
	end

	def self.approved_with_buyer buyer, user
		where(buyer_approved: 'Approved', courier_id: Courier.buyer_delivered(buyer, user).ids)
	end

	def self.pending_with_buyer buyer, user
		where(buyer_approved: 'Pending', courier_id: Courier.buyer_delivered(buyer, user).ids)
	end
end
