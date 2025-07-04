class SendReminderMailer < ApplicationMailer
   
  def send_mail team, items
  	mail_ids = team.team_members.pluck(:email)
 		@items = items
 		@buyer = team.buyer
    @items.each_with_index do |item, index|
      if item.item_image.attached?
        begin
          blob = item.item_image.blob
          filename = blob&.filename&.to_s || "item_#{index}"
          attachments[index.to_s + filename] = item.item_image.download
        rescue ActiveStorage::FileNotFoundError
          Rails.logger.warn "File not found for item #{item.id}, skipping attachment"
        end
      end
    end
 		attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/ei_logo.jpg") if @buyer.is_eclat
    attachments['Pending items.pdf'] = WickedPdf.new.pdf_from_string(
    render_to_string(template: 'items/pending_items', formats: [:pdf], locals: {items: @items}))
   	mail(to: mail_ids.flatten, subject: "PENDING APPROVALS as on #{Date.today.strftime('%d-%m-%Y')} - #{team.name}")
    mail.delivery_method.settings.merge!(DynamicSmtpSettings.smtp_settings(@buyer.email))
  end

end
