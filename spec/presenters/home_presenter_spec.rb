require 'spec_helper'
require 'rails_helper'

describe HomePresenter do
  let(:user) { double('User', id: 1, name: 'Test User') }
  let(:presenter) { HomePresenter.new(user) }

  describe '#gather_data' do
    it 'returns a hash with couriers and items data' do
      data = presenter.gather_data

    end

  end

end