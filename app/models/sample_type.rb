class SampleType < ApplicationRecord

	has_many :items

	validates :name, {presence: true, uniqueness: {case_sensitive: true}, length: {minimum: 3, maximum: 50}}
end
