require_relative '../lib/car.rb'
require_relative '../lib/rental.rb'

describe Rental do
  describe '#cost' do
    subject { rental.cost }
    let(:car) { Car.new(1, 2000, 10) }

    context 'with valid data' do
      let(:rental) { Rental.new(1, car, '2017-12-8', '2017-12-10', 100) }

      it { expect(subject).to eq(7000) }
    end
  end
end
