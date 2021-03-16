class BuyersController < ApplicationController
  before_action :set_buyer, only: %i[ show edit update destroy get_teams pending_buyer_comments update_pending_buyer_comments]

  def index
    @buyers = Buyer.all
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
      format.js {render file: "buyers/form.js.erb"}
    end 
  end

  def edit
    respond_to do |format|
      format.js {render file: "buyers/form.js.erb"}
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
      format.html { redirect_to buyers_url, notice: "Vendor was successfully destroyed." }
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
    @items = Item.where(buyer_comments: [nil, ''], courier_id: Courier.where(buyer_id: @buyer.id).where.not(delivery_date: nil).ids)
  end

  def update_pending_buyer_comments
    items = Item.where(id: params[:item_ids].keys)
    items.update(buyer_comments: 'Comments given')
    redirect_to pending_buyer_comments_buyer_path(@buyer.id), notice: 'Vendor Comments updated successfully.'
  end

  private
    def set_buyer
      @buyer = Buyer.find(params[:id])
    end

    def buyer_params
      params.require(:buyer).permit(:name, :address)
    end
end