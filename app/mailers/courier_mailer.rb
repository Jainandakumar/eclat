class CourierMailer < ApplicationMailer
   
   def send_mail(courier)
   	@courier = courier
   	mail_ids = @courier.team.team_members.pluck(:email)
   	@items = @courier.items.sort_by{|c| c.serial_number.to_i}
      @items.each_with_index do |item, index|
         if item.item_image.attached?
            blob = item.item_image.blob
            filename = blob&.filename&.to_s || "item_#{index}"
            attachments[index.to_s + filename] = item.item_image.download
         end
      end
   	attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/ei_logo.jpg") if @courier.buyer.is_eclat
   	attachments[@courier.airway_bill_number+'.pdf'] = WickedPdf.new.pdf_from_string(
      render_to_string(template: 'items/sample_photos', formats: [:pdf], locals: {items: @items}))
      mail(to: mail_ids, subject: "Courier sent on #{@courier.courier_date.strftime('%d-%m-%Y')} - #{@courier.team_name}")
      mail.delivery_method.settings.merge!(DynamicSmtpSettings.smtp_settings(@courier.buyer.email))
   end

end
