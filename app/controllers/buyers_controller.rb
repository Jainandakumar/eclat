class BuyersController < ApplicationController
  before_action :set_buyer, only: %i[ show edit update destroy get_teams pending_buyer_comments update_pending_buyer_comments pending_buyer_approval update_pending_buyer_approval buyer_approved_items update_buyer_approved_items]

  def index
    redirect_to root_path unless current_user.is_admin
    @presenter = BuyersPresenter.new.gather_data
    respond_to do |format|
      format.js {render file: "buyers/index.js.erb"}
      format.html
    end
  end

  def show
    respond_to do |format|
      format.js {render file: "teams/index.js.erb"}
      format.html
    end
  end

  def new
    @buyer = Buyer.new
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
    @buyer = Buyer.new(buyer_params)
    respond_to do |format|
      if @buyer.save
        format.html { redirect_to buyers_path, notice: "Vendor was successfully created." }
        format.js {redirect_to buyers_path, notice: "Vendor was successfully created."}
      else
        format.html { render :new, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @buyer.update(buyer_params)
        format.html { redirect_to buyers_path, notice: "Vendor was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @buyer.destroy
    respond_to do |format|
      format.html { redirect_to buyers_url, notice: "Vendor was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def get_teams
    teams = @buyer.teams
    if request.xhr?
      respond_to do |format|
        format.json {
          render json: {teams: teams}
        }
      end
    end
  end

  def pending_buyer_comments
    @presenter = BuyersPresenter.new(@buyer, current_user).pending_buyer_comments
  end

  def update_pending_buyer_comments
    handle_update(:update_pending_buyer_comments, pending_buyer_comments_buyer_path(@buyer.id))
  end

  def pending_buyer_approval
    @presenter = BuyersPresenter.new(@buyer, current_user).pending_buyer_approval
  end

  def update_pending_buyer_approval
    handle_update(:update_pending_buyer_approval, pending_buyer_approval_buyer_path(@buyer.id), 'Vendor Approval updated successfully.')
  end

  def buyer_approved_items
    @presenter = BuyersPresenter.new(@buyer, current_user).buyer_approved_items
  end

  def update_buyer_approved_items
    handle_update(:update_buyer_approved_items, buyer_approved_items_buyer_path(@buyer.id), 'Items made to Pending successfully.')
  end

  private
    def set_buyer
      @buyer = Buyer.find(params[:id])
    end

    def buyer_params
      params.require(:buyer).permit(:name, :address, :company, :email)
    end

  def handle_update(adapter_method, redirect_path, success_message = nil)
    permitted_items = params.require(:items).permit!.to_h
    begin
      message = DataAdapters::ItemAdapter.new.public_send(adapter_method, permitted_items)
      redirect_to redirect_path, notice: success_message || message
    rescue StandardError => e
      redirect_to redirect_path, alert: "Failed to update items: #{e.message}"
    end
  end

end