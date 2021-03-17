class Courier < ApplicationRecord

	belongs_to :buyer
	belongs_to :team
	has_many :items, dependent: :destroy
	has_one_attached :airway_bill_image

	validates :airway_bill_number, {presence: true, uniqueness: {case_sensitive: true}, length: {minimum: 3, maximum: 75}}
	validates :courier_date, presence: true
end
