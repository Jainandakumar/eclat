class ReportsController < ApplicationController
	def index
		@items = Item.order(:created_at)
	end
end