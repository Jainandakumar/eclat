class Item < ApplicationRecord

	belongs_to :sample_type
	belongs_to :courier
	has_one_attached :item_image
end
