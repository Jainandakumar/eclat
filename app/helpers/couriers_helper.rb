module CouriersHelper

	def courier_date_display courier
		courier.courier_date.present? ? date_display(courier.courier_date) : '-'
	end

	def delivery_date_display courier
		courier.delivery_date.present? ? date_display(courier.delivery_date) : fa_pending
	end

	def approved_display courier
		courier.approved ? fa_approved : fa_pending
	end

end
