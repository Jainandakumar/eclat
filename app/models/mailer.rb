class Mailer

  def initialize(params)
    @params = params
  end

  def process_mailer
    email_for = @params[:email_for]
    case email_for
    when 'remainder_mail'
      return_path, message = remainder_mail
    else
      return_path, message = send_all_items(id, remarks)
    end
    return return_path, message
  end
  def remainder_mail
    if @params[:from] == 'reports'
      send_all_items
      return_path = 'reports_path'
    elsif @params[:from] == 'pending_buyer_comments'
      send_all_items
      return_path = 'pending_comments_path'
    else
      send_all_items(@params[:id], @params[:remarks])
      return_path = 'pending_buyer_comments_buyer_path(@params[:id])'
    end
    return return_path, 'Reminder mail successfully sent.'
  end

  def send_all_items(buyer_id = nil, remarks = [])
    sent_couriers = if buyer_id.present?
                      remarks.each do |remark|
                        Item.find(remark[1].keys[0]).update(remarks: remark[1].values[0])
                      end
                      Courier.buyer_delivered(Buyer.find(buyer_id), current_user)
                    else
                      Courier.delivered(current_user)
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

end