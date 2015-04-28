require_relative '../lib/car.rb'
require_relative '../lib/rental.rb'
require_relative '../lib/rental_options.rb'

describe Rental do
  describe '#cost' do
    subject { rental.cost }
    let(:car) { Car.new(1, 2000, 10) }

    context 'with 1 day rental duration' do
      let(:rental) do
        Rental.new(
          id: 1, car: car, start_date: '2015-12-8',
          end_date: '2015-12-8', distance: 100
        )
      end

      it { expect(subject).to eq(3000) }
    end

    context 'with 2 days rental duration' do
      let(:rental) do
        Rental.new(
          id: 1, car: car, start_date: '2015-03-31',
          end_date: '2015-04-01', distance: 300
        )
      end

      it { expect(subject).to eq(6800) }
    end

    context 'with 12 days rental duration' do
      let(:rental) do
        Rental.new(
          id: 1, car: car, start_date: '2015-07-3',
          end_date: '2015-07-14', distance: 1000
        )
      end

      it { expect(subject).to eq(27_800) }
    end
  end

  describe '#commission' do
    subject { rental.commission }
    let(:car) { Car.new(1, 2000, 10) }

    context 'with 1 day rental duration' do
      let(:rental) do
        Rental.new(
          id: 1, car: car, start_date: '2015-12-8',
          end_date: '2015-12-8', distance: 100
        )
      end

      it { expect(subject.insurance_fee).to eq(450) }
      it { expect(subject.assistance_fee).to eq(100) }
      it { expect(subject.drivy_fee).to eq(350) }
    end
  end

  describe '#deductible_reduction' do
    subject { rental.deductible_reduction }
    let(:car) { Car.new(1, 2000, 10) }

    context 'with deductible_reduction option' do
      let(:options) { RentalOptions.new(deductible_reduction: true) }
      let(:rental) do
        Rental.new(
          id: 1, car: car, start_date: '2015-12-8',
          end_date: '2015-12-8', distance: 100, options: options
        )
      end

      it { expect(subject).to eq(400) }
    end

    context 'without deductible_reduction option' do
      let(:options) { RentalOptions.new(deductible_reduction: false) }
      let(:rental) do
        Rental.new(
          id: 1, car: car, start_date: '2015-12-8',
          end_date: '2015-12-8', distance: 100, options: options
        )
      end

      it { expect(subject).to eq(0) }
    end
  end
end
