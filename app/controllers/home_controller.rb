class HomeController < ApplicationController
  def index
  end

  def pending_comments
    @presenter = HomePresenter.new(current_user).pending_comments
  end

  def pending_approval
    @presenter = HomePresenter.new(current_user).pending_approval
  end

  def approved_items
    @presenter = HomePresenter.new(current_user).approved_items
  end

end
