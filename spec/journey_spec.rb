require 'journey'

describe Journey do
  let(:station) { double :station, zone: 1}
  let(:penalty) { Journey::PENALTY_FARE }

  it 'knows if a journey is not complete' do
    expect(subject).not_to be_complete
  end

  it 'has a penalty fare by default' do
    expect(subject.penalty_fare).to eq penalty
  end

  it 'returns itself when exiting a journey' do
    expect(subject.finish(station)).to eq(subject)
  end

  context 'given an entry station' do
    subject {described_class.new(station)}

    it 'has an entry station' do
      expect(subject.entry_station).to eq station
    end

    it 'returns a penalty fare if no exit station given' do
      expect(subject.penalty_fare).to eq penalty
    end

    context 'given an exit station' do
      let(:other_station) { double :other_station}

      before do
        subject.finish(other_station)
      end

      it 'calculates a fare' do
        expect(subject.fare).to eq 1
      end

      it 'knows if a journey is complete' do
        expect(subject).to be_complete
      end
    end
  end
end
