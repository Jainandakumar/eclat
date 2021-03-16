class TeamMember < ApplicationRecord

	belongs_to :team

	validates :name, {presence: true, uniqueness: {case_sensitive: true, scope: :team_id}, length: {minimum: 3, maximum: 75}}
	validates :email, {presence: true, uniqueness: {scope: :team_id}, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ } }
	validates :phone, {length: {maximum: 10}}

end
