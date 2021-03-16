class Buyer < ApplicationRecord

	has_many :couriers
	has_many :teams
	
	validates :name, {presence: true, uniqueness: {case_sensitive: true}, length: {minimum: 3, maximum: 75}}
	validates :address, {presence: true, length: {minimum: 3, maximum: 500}}

end
