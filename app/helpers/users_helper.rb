module UsersHelper

	def role_display user
    user.is_admin ? 'Admin' : user.role
  end

  def status user
    user.is_active ? fa_active : fa_inactive
  end

end
