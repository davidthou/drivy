require_relative '../lib/car.rb'
require_relative '../lib/rental.rb'
require_relative '../lib/rental_options.rb'
require_relative '../lib/rental_modification.rb'

describe RentalModification do
  describe '#to_hash' do
    subject { rental_modification.to_hash }
    let(:car) { Car.new(1, 2000, 10) }
    let(:options) { RentalOptions.new(deductible_reduction: true) }
    let(:rental) do
      Rental.new(
        id: 1, car: car, start_date: '2015-12-8',
        end_date: '2015-12-8', distance: 100, options: options
      )
    end

    context 'increasing driver cost' do
      let(:rental_modification) do
        RentalModification.new(
          id: 1, rental: rental, end_date: '2015-12-10', distance: 150
        )
      end

      actions = {
        id: 1,
        rental_id: 1,
        actions:
          [{ who: 'driver', type: 'debit', amount: 4900 },
           { who: 'owner', type: 'credit', amount: 2870 },
           { who: 'insurance', type: 'credit', amount: 615 },
           { who: 'assistance', type: 'credit', amount: 200 },
           { who: 'drivy', type: 'credit', amount: 1215 }]
      }
      it { expect(subject).to eq(actions) }
    end

    context 'decreasing driver cost' do
      let(:rental_modification) do
        RentalModification.new(
          id: 1, rental: rental, distance: 50
        )
      end

      actions = {
        id: 1,
        rental_id: 1,
        actions:
          [{ who: 'driver', type: 'credit', amount: 500 },
           { who: 'owner', type: 'debit', amount: 350 },
           { who: 'insurance', type: 'debit', amount: 75 },
           { who: 'assistance', type: 'credit', amount: 0 },
           { who: 'drivy', type: 'debit', amount: 75 }]
      }
      it { expect(subject).to eq(actions) }
    end
  end
end
