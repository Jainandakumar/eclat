module BuyersHelper

  def buyers_present?
    yield if buyers.any?
  end

  def no_buyers_present?
    yield unless buyers.any?
  end

  def buyers
    @presenter.buyers
  end

end
