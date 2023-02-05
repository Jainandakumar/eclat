class ReportsController < ApplicationController
	def index
		@items = Item.sent(current_user).order(:created_at)
	end
end