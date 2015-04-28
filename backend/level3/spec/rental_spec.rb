require_relative '../lib/car.rb'
require_relative '../lib/rental.rb'

describe Rental do
  describe '#cost' do
    subject { rental.cost }
    let(:car) { Car.new(1, 2000, 10) }

    context 'with 1 day rental duration' do
      let(:rental) { Rental.new(1, car, '2015-12-8', '2015-12-8', 100) }

      it { expect(subject).to eq(3000) }
    end

    context 'with 2 days rental duration' do
      let(:rental) { Rental.new(1, car, '2015-03-31', '2015-04-01', 300) }

      it { expect(subject).to eq(6800) }
    end

    context 'with 12 days rental duration' do
      let(:rental) { Rental.new(1, car, '2015-07-3', '2015-07-14', 1000) }

      it { expect(subject).to eq(27_800) }
    end
  end

  describe '#commission' do
    subject { rental.commission }
    let(:car) { Car.new(1, 2000, 10) }

    context 'with 1 day rental duration' do
      let(:rental) { Rental.new(1, car, '2015-12-8', '2015-12-8', 100) }

      it { expect(subject.insurance_fee).to eq(450) }
      it { expect(subject.assistance_fee).to eq(100) }
      it { expect(subject.drivy_fee).to eq(350) }
    end
  end
end
