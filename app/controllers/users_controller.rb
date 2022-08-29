class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  def index
    @users = User.order(:name)
    respond_to do |format|
      format.js {render file: "users/index.js.erb"}
      format.html { }
    end
  end

  def new
    @user = User.new
    respond_to do |format|
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: "Staff was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: "Staff was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "Staff was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :phone, :is_active, :role)
    end
end
