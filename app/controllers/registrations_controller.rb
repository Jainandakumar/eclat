class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
  	@user = User.new(user_params)
  	@user.password = 'welcome123'
  	@user.password_confirmation = 'welcome123'
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: "User was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update
    super
  end

  def user_params
  	params.require(:user).permit(:name, :email, :phone, :is_active, :role)
	end
end 