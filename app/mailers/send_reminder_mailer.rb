class SendReminderMailer < ApplicationMailer

	default from: 'jainandatest@gmail.com'
   
  def send_mail mail_ids, items
 		@items = items
 		attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/ei_logo.jpg")
    attachments['Pending items.pdf'] = WickedPdf.new.pdf_from_string(
    render_to_string(pdf: 'pending_items', template: 'items/pending_items.pdf.erb', locals: {items: @items}))
   	mail(to: mail_ids.flatten, subject: 'Comments pending for items')
  end

end
