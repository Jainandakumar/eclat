class SendReminderMailer < ApplicationMailer

	default from: 'jainandatest@gmail.com'
   
  def send_mail team, items
  	mail_ids = team.team_members.pluck(:email)
 		@items = items
 		@buyer = team.buyer
 		attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/ei_logo.jpg")
    attachments['Pending items.pdf'] = WickedPdf.new.pdf_from_string(
    render_to_string(pdf: 'pending_items', template: 'items/pending_items.pdf.erb', locals: {items: @items}))
   	mail(to: mail_ids.flatten, subject: "Awaiting comments as on #{Date.today.strftime('%d-%m-%Y')} - #{team.name}")
  	items.map{|i| i.update(remarks: '')}
  end

end
