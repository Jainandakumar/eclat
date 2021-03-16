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
	
end
