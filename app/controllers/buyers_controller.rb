class BuyersController < ApplicationController
  before_action :set_buyer, only: %i[ show edit update destroy get_teams pending_buyer_comments update_pending_buyer_comments pending_buyer_approval update_pending_buyer_approval buyer_approved_items update_buyer_approved_items]

  def index
    @buyers = Buyer.all.includes(:teams, :couriers)
    respond_to do |format|
      format.js {render file: "buyers/index.js.erb"}
      format.html { }
    end
  end

  def show
    respond_to do |format|
      format.js {render file: "teams/index.js.erb"}
      format.html { }
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
    @items = Item.pending_buyer_comments_with_buyer(@buyer).includes(:courier, :sample_type)
  end

  def update_pending_buyer_comments
    ids = params[:items][:id].keys
    ids.each do |id|
      item = Item.find(id)
      item.update(buyer_approved: params[:items][:buyer_approved][id])
    end
    redirect_to pending_buyer_comments_buyer_path(@buyer.id), notice: 'Vendor Comments updated successfully.'
  end

  def pending_buyer_approval
    @items = Item.pending_with_buyer(@buyer).includes(:courier, :sample_type)
  end

  def update_pending_buyer_approval
    ids = params[:items][:id].keys
    Item.where(id: ids).update_all(buyer_approved: 'Approved')
    redirect_to pending_buyer_approval_buyer_path(@buyer.id), notice: 'Vendor Approval updated successfully.'
  end

  def buyer_approved_items
    @items = Item.approved_with_buyer(@buyer).includes(:courier, :sample_type)
  end

  def update_buyer_approved_items
    ids = params[:items][:id].keys
    ids.each do |id|
      item = Item.find(id)
      item.update(buyer_approved: 'Pending')
    end
    redirect_to buyer_approved_items_buyer_path(@buyer.id), notice: 'Items made to Pending successfully.'
  end

  private
    def set_buyer
      @buyer = Buyer.find(params[:id])
    end

    def buyer_params
      params.require(:buyer).permit(:name, :address, :company)
    end
end