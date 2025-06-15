class CourierPresenter

  attr_reader :approved, :has_items, :airway_bill_image, :team_name, :items
  def initialize(courier)
    @courier = courier
  end

  def gather_data
    @approved = @courier.approved
    @has_items = @courier.items.any?
    @airway_bill_image = ImagesPresenter.new(@courier.airway_bill_image).get_image
    @team_name = @courier.team_name
    @items = get_items
    self
  end

  private

  def get_items
    items = []
    @courier.items.includes(:sample_type).with_attached_item_image.sort_by { |item| item.serial_number.to_i }.each do |item|
      items_hash = {}
      items_hash['id'] = item.id
      items_hash['serial_number'] = item.serial_number.to_i
      items_hash['sample_type'] = item.sample_type_name
      items_hash['description'] = item.description
      items_hash['number_of_samples'] = item.number_of_samples
      items_hash['image'] = ImagesPresenter.new(item.item_image).get_image
      items_hash['buyer_comments'] = item.buyer_comments.present? ? item.buyer_comments : 'NA'
      items << items_hash
    end
    items
  end

end