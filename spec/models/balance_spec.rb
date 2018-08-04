require "rails_helper"

describe "Balance" do
  let!(:balance){FactoryGirl.create :balance, amount: 10.0}

  describe "#deduct_amount!" do
    it "should deduct exact amount" do
      balance.deduct_amount! 5.0
      expect(balance.amount).to eq 5.0
    end

    it "should return false if the deduction value is greater than amount" do
      expect(balance.deduct_amount! 11.0).to eq false
      expect(balance.amount).to eq 10.0
    end
  end

  describe "#add_amount!" do
    it "should add exact amount to balance" do
      balance.add_amount! 5.0
      expect(balance.amount).to eq 15.0
    end
  end
end
