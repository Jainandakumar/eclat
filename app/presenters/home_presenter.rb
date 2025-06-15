class HomePresenter
  attr_reader :return_pbc, :return_bai, :return_pba

  def initialize(current_user)
    @current_user = current_user
  end

  def pending_comments
    @return_pbc = build_courier_data(Item.pending_buyer_comments(@current_user), '')
    self
  end

  def approved_items
    @return_bai = build_courier_data(Item.approved(@current_user), 'Approved')
    self
  end

  def pending_approval
    @return_pba = build_courier_data(Item.pending(@current_user), 'Pending')
    self
  end

  private

  def build_courier_data(items_scope, approval_status)
    courier_ids = items_scope.pluck(:courier_id)
    Courier.where(id: courier_ids).includes(:items).group_by(&:buyer).map do |buyer, couriers|
      {
        buyer: buyer,
        buyer_name: buyer.name,
        no_of_couriers: couriers.count,
        no_of_samples: couriers.sum { |c| c.items.where(buyer_approved: approval_status).count }
      }
    end
  end
end