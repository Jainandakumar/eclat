class SendReminderMailer < ApplicationMailer
   
  def send_mail team, items
  	mail_ids = team.team_members.pluck(:email)
 		@items = items
 		@buyer = team.buyer
    @items.each_with_index do |item, index|
      blob = item.item_image.blob
      attachments[index.to_s+blob&.filename.to_s] = item.item_image.download
    end
 		attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/ei_logo.jpg") if @buyer.is_eclat
    attachments['Pending items.pdf'] = WickedPdf.new.pdf_from_string(
    render_to_string(pdf: 'pending_items', template: 'items/pending_items.pdf.erb', locals: {items: @items}))
   	mail(to: mail_ids.flatten, subject: "PENDING APPROVALS as on #{Date.today.strftime('%d-%m-%Y')} - #{team.name}")
  	items.map{|i| i.update(remarks: '')}
    mail.delivery_method.settings.merge!(DynamicSmtpSettings.smtp_settings(@buyer.email))
  end

end
