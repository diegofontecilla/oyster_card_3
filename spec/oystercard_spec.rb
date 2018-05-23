require 'oystercard'

describe Oystercard do
  let(:station) { double :station }
  let(:min_balance) { described_class::MINIMUM_BALANCE }
  let(:min_fare) { described_class::MINIMUM_FARE }

  context '#initialize' do
    it 'starts with a balance of zero' do
      expect(subject.balance).to be == 0
    end
  end

  context "#balance" do
    it "Return the current balance" do
      card = Oystercard.new
      card.balance
      expect(card.balance).to be_an Integer
    end
  end

  context "#top_up" do
    it 'can top up the balance' do
      top_up_amount = Oystercard::MINIMUM_BALANCE
      subject.top_up(top_up_amount)
      expect(subject.balance).to eq min_balance
    end

    it "raises an error if the maximum balance is exceeded" do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      subject.top_up(maximum_balance)
      expect{ subject.top_up min_balance }.to raise_error "maximum balance of #{maximum_balance} exceeded."
    end
  end

  context "#in_journey?" do
    it 'knows when it\'s in use' do
      expect(subject).not_to be_in_journey
    end
  end

    context 'touch in' do
      it 'can touch in' do
        subject.top_up(min_balance + 1)
        subject.touch_in(station)
        expect(subject).to be_in_journey
      end

      it 'raises an error if balance is less than minimum' do
        expect{ subject.touch_in(station) }.to raise_error "balance is below £#{Oystercard::MINIMUM_BALANCE}"
      end
    end

  context 'touch out' do
    it 'can touch out' do
      subject.top_up(10)
      subject.touch_in(station)
      subject.touch_out
      expect(subject).not_to be_in_journey
    end

    it 'reduces the card balance by minimum fare' do
      subject.top_up(10)
      subject.touch_in(station)
      expect { subject.touch_out }.to change { subject.balance }.by -min_fare
    end
  end

  it 'stores the entry station' do
    subject.top_up(4)
    subject.touch_in(station)
    expect(subject.entry_station).to eq station
  end
end

# private
#
# context "#deduct" do
#   it 'deducts an amount from the balance' do
#     subject.top_up(20)
#     expect { subject.deduct 3}.to change{ subject.balance }.by -3
#   end
# end
