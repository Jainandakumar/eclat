class CourierMailer < ApplicationMailer

	default from: 'jainandatest@gmail.com'
   
   def send_mail(courier)
   	@courier = courier
   	mail_ids = @courier.team.team_members.pluck(:email)
   	@items = @courier.items.order(:serial_number)
      @items.each_with_index do |item, index|
         blob = item.item_image.blob
         attachments[index.to_s+blob&.filename.to_s] = item.item_image.download
      end
   	attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/ei_logo.jpg") if @courier.buyer.is_eclat
   	attachments[@courier.airway_bill_number+'.pdf'] = WickedPdf.new.pdf_from_string(
      render_to_string(pdf: 'sample_photos', template: 'items/sample_photos.pdf.erb', locals: {items: @items}))
      mail(to: mail_ids, subject: "Courier sent on #{@courier.courier_date.strftime('%d-%m-%Y')} - #{@courier.team_name}")
   end

end
