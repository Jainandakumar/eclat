class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update destroy]
  before_action :load_buyers, only: %i[new edit update create]
  before_action :ensure_admin

  def index
    @users = User.order(:name)
    respond_to do |format|
      format.js { render "users/index.js.erb" }
      format.html
    end
  end

  def new
    @user = User.new
    respond_to :js
  end

  def edit
    respond_to :js
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: "Staff was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    params[:user][:buyer_ids].reject!(&:empty?) if params[:user][:buyer_ids].present?
    if @user.update(user_params)
      redirect_to users_path, notice: "Staff was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: "Staff was successfully removed."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :phone, :is_active, :role, :email, buyer_ids: [])
  end

  def load_buyers
    @buyers = Buyer.order(:name)
  end

  def ensure_admin
    redirect_to root_path unless current_user.is_admin
  end
end