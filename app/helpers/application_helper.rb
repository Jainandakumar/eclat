module ApplicationHelper

	def is_admin?
		current_user.present? && current_user.is_admin
	end

	def is_manager?
		current_user.present? && current_user.role == 'Manager'
	end

	def is_staff?
		current_user.present? && current_user.role == 'Staff'
	end

	def date_display date
		date.strftime("%d-%m-%Y")
	end

	def fa_active
		'<i class="fa fa-check-circle text-success" aria-hidden="true" title="Active"></i>'.html_safe
	end

	def fa_inactive
		'<i class="fa fa-times-circle text-danger" aria-hidden="true" title="Inactive"></i>'.html_safe
	end

	def fa_approved
		'<i class="fa fa-check-circle text-success" aria-hidden="true" title="Approved"></i>'.html_safe
	end

	def fa_pending
		'<i class="fa fa-spinner text-warning" aria-hidden="true" title="Pending"></i>'.html_safe
	end

	def fa_rejected
		'<i class="fa fa-times-circle text-danger" aria-hidden="true" title="Rejected"></i>'.html_safe
	end
	
end
