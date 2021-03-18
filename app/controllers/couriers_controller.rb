class CouriersController < ApplicationController

	before_action :set_buyer, except: [:all_couriers, :new_courier, :save_courier, :undelivered_couriers, :update_courier_delivery_dates]
	before_action :set_courier, except: [:index, :new, :create, :all_couriers, :new_courier, :save_courier, :undelivered_couriers, :update_courier_delivery_dates]

	def index
		@couriers = @buyer.couriers.order(:courier_date)
		respond_to do |format|
  		format.js {render file: "couriers/index.js.erb"}
  		format.html{}
  	end
	end

	def new
		@courier = Courier.new
		@buyer_id = params[:buyer_id]
		@buyers = Buyer.order(:name)
	end

	def create
		@buyers = Buyer.order(:name)
		@courier = Courier.new(courier_params)
		if @courier.save
			redirect_to sample_type_items_buyer_courier_path(@buyer, @courier), notice: "Courier was successfully created."
		else
			render :new, status: :unprocessable_entity
		end
	end

	def edit
    respond_to do |format|
      format.js {render file: "couriers/form.js.erb"}
    end
  end

  def update
    respond_to do |format|
      if @courier.update(courier_params)
        format.html { redirect_to buyer_couriers_path(@buyer), notice: "Courier was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.js
      end
    end
  end

	def show
		@approved = @courier.approved
		respond_to do |format|
	      format.js {render file: "items/index.js.erb"}
	      format.html { }
	    end
	end

	def sample_type_items
		@sample_types = SampleType.order(:name)
		@items = @courier.items.where(sample_type_id: params[:sample_type_id]).order(:serial_number)
		respond_to do |format|
      format.js {render file: "couriers/sample_type_items.js.erb"}
      format.html {}
      format.json { render file: "couriers/sample_type_items.js.erb" }
    end
	end

	def approve_status
		@courier.update_attributes(approved: true)
		redirect_to buyer_courier_path(@buyer, @courier), notice: "Courier was successfully approved and mail was sent to the team members."
		CourierMailer.send_mail(@courier).deliver_later
	end

	def destroy
		@courier.destroy
		redirect_to buyer_couriers_path(@buyer), notice: "Courier was successfully destroyed."
	end

	def all_couriers
		@couriers = Courier.order(:courier_date).includes(:buyer, :team, :items)
	end

	def new_courier
		@buyers = Buyer.order(:name)
		@courier = Courier.new
	end

	def save_courier
		@buyers = Buyer.order(:name)
		@courier = Courier.new(courier_params)
		if @courier.save
			redirect_to sample_type_items_buyer_courier_path(@courier.buyer, @courier), notice: "Courier was successfully created."
		else
			render :new_courier, status: :unprocessable_entity
		end
	end

	def undelivered_couriers
		@undelivered_couriers = Courier.where(approved: true, delivery_date: nil)
	end

	def update_courier_delivery_dates
		couriers = Courier.where(id: params[:courier_ids].keys)
		delivery_date = Date.new(params[:delivery_date]['(1i)'].to_i,params[:delivery_date]['(2i)'].to_i,params[:delivery_date]['(3i)'].to_i) rescue Date.today
		couriers.update(delivery_date: delivery_date)
		redirect_to undelivered_couriers_path, notice: 'Delivery Date updated successfully.'
	end

	private

	def courier_params
		params.require(:courier).permit(:airway_bill_number, :buyer_comments, :buyer_id, :courier_date, :description, :received_status, :approved, :team_id, :delivery_date, :number_of_items, :airway_bill_image)
	end

	def set_courier
		@courier = Courier.find(params[:id])
	end

	def set_buyer
      @buyer = Buyer.find(params[:buyer_id])
    end
end
