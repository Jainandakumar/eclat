class ItemsPresenter
  def initialize(items = nil)
    @items = items
  end

  def gather_data
    @items
  end
end