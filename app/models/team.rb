class Team < ApplicationRecord

	belongs_to :buyer
	has_many :couriers
	has_many :team_members, dependent: :destroy

	validates :name, {presence: true, uniqueness: {case_sensitive: true}, length: {minimum: 3, maximum: 75}}
	
end
