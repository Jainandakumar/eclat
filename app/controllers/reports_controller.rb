class ReportsController < ApplicationController

	before_action :get_items

	def index
	end

	def download_report
		respond_to do |format|
	    format.xlsx {render xlsx: 'download_report',filename: "Report.xlsx"}
	    format.html { render :index }
	  end	
	end

	private

	def get_items
		@items = Item.sent(current_user).includes(courier: [:buyer, :team]).order(:created_at)
	end
end