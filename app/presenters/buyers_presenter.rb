class BuyersPresenter
  attr_reader :buyers, :return_pbc, :return_pba, :return_bai

  def initialize(buyer = nil, current_user = nil)
    @buyer = buyer
    @current_user = current_user
  end

  def gather_data
    @buyers = Buyer.includes(:teams, :couriers).order(:name)
    self
  end

  def pending_buyer_comments
    @return_pbc = group_and_format_items(Item.pending_buyer_comments_with_buyer(@buyer, @current_user))
    self
  end

  def pending_buyer_approval
    @return_pba = group_and_format_items(Item.pending_with_buyer(@buyer, @current_user))
    self
  end

  def buyer_approved_items
    @return_bai = group_and_format_items(Item.approved_with_buyer(@buyer, @current_user))
    self
  end

  private

  def group_and_format_items(items_scope)
    items_scope.with_attached_item_image
               .includes(:courier, :sample_type)
               .group_by(&:courier)
               .map { |courier, items| { courier: courier, items: items.map { |item| format_item_data(item) } } }
  end

  def format_item_data(item)
    {
      id: item.id,
      description: item.description,
      sample_type_name: item.sample_type_name,
      number_of_samples: item.number_of_samples,
      item_image: ImagesPresenter.new(item.item_image).get_image("80x80"),
      remarks: get_na(item.remarks),
      buyer_comments: get_na(item.buyer_comments)
    }
  end

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

  def get_na(value)
    value.presence || 'NA'
  end
end