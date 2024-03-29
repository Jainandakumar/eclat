class ItemsController < ApplicationController

	before_action :set_courier, except: [:send_reminder_mail, :pending_buyer_comments, :pending_buyer_approval, :buyer_approved_items]
	before_action :set_item, except: [:new, :create, :save_items, :delete_multiple_items, :edit_delivery_items, :update_delivery_items, :send_reminder_mail, :pending_buyer_comments, :pending_buyer_approval, :buyer_approved_items]

	def new
		@item = Item.new
		@sample_type_id = params[:sample_type_id]
		@courier_show_page = params[:courier_show_page]
	    respond_to do |format|
	      format.js {render file: "items/form.js.erb"}
	    end

	end

	def create
		@item = Item.new(item_params)
		redirect_path = params[:courier_show_page].present? ? buyer_courier_path(@buyer, @courier) : sample_type_items_buyer_courier_path(@buyer, @courier, sample_type_id: @item.sample_type_id)
		respond_to do |format|
	      if @item.save
	        format.html { redirect_to redirect_path, notice: "Item was successfully added." }
	      else
	        format.html { render :new, status: :unprocessable_entity }
	        format.js
	      end
	    end
	end

	def edit
		@sample_type_id = params[:sample_type_id]
		@courier_show_page = params[:courier_show_page]
		respond_to do |format|
	      format.js
	    end
	end

	def update
		redirect_path = params[:courier_show_page].present? ? buyer_courier_path(@buyer, @courier) : sample_type_items_buyer_courier_path(@buyer, @courier, sample_type_id: @item.sample_type_id)
		respond_to do |format|
	      if @item.update(item_params)
	        format.html { redirect_to redirect_path, notice: "Item was successfully updated." }
	      else
	        format.html { render :edit, status: :unprocessable_entity }
	        format.js
	      end
	    end
	end

	def destroy
		sample_type_id = @item.sample_type_id
		@item.destroy
		redirect_to buyer_courier_path(@buyer, @courier), notice: "Item was successfully deleted."
		@courier.items.where(sample_type_id: sample_type_id).order(:id).each_with_index do |item, index|
			item.update(serial_number: index+1)
		end
	end

	def save_items
		params[:items].values.each do |item_param|
			Item.find_or_create_by(serial_number: item_param['serial_number'], courier_id: params['courier_id']) do |item|
				item.description = item_param['description']
				item.sample_type_id = item_param['sample_type_id']
				item.number_of_samples = item_param['number_of_samples']
				item.item_image = item_param['item_image']
				item.save
			end
		end
		redirect_to buyer_courier_path(@buyer, @courier), notice: "Items were created successfully."
	end

	def edit_delivery_items
		@items = @courier.items.sort_by{|c| c.serial_number.to_i}
	end

	def update_delivery_items
		delivery_date = Date.new(params[:courier]['delivery_date(1i)'].to_i,params[:courier]['delivery_date(2i)'].to_i,params[:courier]['delivery_date(3i)'].to_i) rescue Date.today
		@courier.update(delivery_date: delivery_date)
		params[:items].each do |id, item_param|
			item = Item.find(id)
			item.buyer_comments = item_param['buyer_comments']
			item.received_status = true
			item.save
		end
		redirect_to buyer_courier_path(@buyer, @courier), notice: "Vendor comments were created successfully."
	end

	def delete_multiple_items
		@courier.items.where(sample_type_id: params[:sample_type_id]).destroy_all
		redirect_to buyer_courier_path(@buyer, @courier), notice: 'Sample type and items were successfully deleted.'
	end

	def send_reminder_mail
		if params[:from] == 'reports'
			send_all_items
			return_path = reports_path
		elsif params[:from] == 'pending_buyer_comments'
			send_all_items
			return_path = pending_buyer_comments_path
		else
			send_all_items(params[:id], params[:remarks])
			return_path = pending_buyer_comments_buyer_path(params[:id])
		end	
		respond_to do |format|
			format.html {redirect_to return_path, notice: 'Reminder mail successfully sent.'}
			format.json {render json: {status: 200, notice: 'Reminder mail successfully sent.'}}
		end
	end

	def send_all_items(buyer_id = nil, remarks = [])
    sent_couriers = if buyer_id.present? 
    	params[:remarks].each do |remark|
    		Item.find(remark[1].keys[0]).update(remarks: remark[1].values[0])
    	end
      Courier.buyer_delivered(Buyer.find(buyer_id), current_user)
    else
      Courier.delivered
    end
    mail_hash = {}
    sent_couriers.joins(:items).where(items: {buyer_approved: ''}).uniq.group_by(&:team). each do |team, couriers|
      mail_hash[team] = []
      couriers.each do |courier|
        mail_hash[courier.team] << courier.items.where(buyer_approved: '').sort_by{|c| c.serial_number.to_i}
      end
    end
    mail_hash.each do |team, items|
      SendReminderMailer.send_mail(team, items.flatten).deliver_later
    end
	end

	def pending_buyer_comments
		courier_ids = Item.pending_buyer_comments(current_user).pluck(:courier_id)
		@buyers_couriers = Courier.where(id: courier_ids).includes(:team, :items).group_by(&:buyer)
	end

	def pending_buyer_approval
		courier_ids = Item.pending(current_user).pluck(:courier_id)
		@buyers_couriers = Courier.where(id: courier_ids).includes(:team, :items).group_by(&:buyer)
	end

	def buyer_approved_items
		courier_ids = Item.approved(current_user).pluck(:courier_id)
		@buyers_couriers = Courier.where(id: courier_ids).includes(:team, :items).group_by(&:buyer)
	end

	private

	def item_params
		params.require(:item).permit(:serial_number, :description, :sample_type_id, :courier_id, :buyer_comments, :received_status, :number_of_samples, :item_image)
	end

	def set_courier
		@courier = Courier.find(params[:courier_id])
		@buyer = @courier.buyer
	end

	def set_item
		@item = Item.find(params[:id])
	end
end
