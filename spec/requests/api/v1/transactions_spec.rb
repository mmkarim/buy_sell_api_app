require "rails_helper"

describe "Transactions API" do
  let!(:user){ FactoryGirl.create :user }
  let(:token){ Doorkeeper::AccessToken.create(resource_owner_id: user.id).token }

  describe "Get #index" do
    it "should return all transactions of the user" do
      user.transactions.create! asset: :cash, amount: 10.0, type: :top_up
      get "/api/v1/transactions/", params: { access_token: token }
      expect_status(:ok)
      expect_json_types "*", type: :string, amount: :float, txref: :string
      expect_json('0', type: "top_up", amount: 10.0)
    end
  end

  describe "Post #buy" do
    it "should deduct cash balance and add proper amount of gold" do
      cash_amount = 10.0
      user.cash.update_columns amount: cash_amount
      gold_amount = cash_amount * Balance::CASH_TO_GOLD_RATE

      post "/api/v1/transactions/buy", params: { cash_amount: cash_amount, access_token: token }
      expect_status(:created)
      expect(user.gold.reload.amount).to eq gold_amount
      expect(user.cash.reload.amount).to eq 0

      expect(user.transactions.count).to eq 1
      expect(user.transactions.last.type).to eq "buy"
    end
  end

  describe "Post #sell" do
    it "should deduct gold balance and increase relative amount of cash" do
      gold_amount = 1.0
      user.gold.update_columns amount: gold_amount
      cash_amount = gold_amount * Balance::GOLD_TO_CASH_RATE

      post "/api/v1/transactions/sell", params: { gold_amount: gold_amount, access_token: token }
      expect_status(:created)
      expect(user.cash.reload.amount).to eq cash_amount
      expect(user.gold.reload.amount).to eq 0

      expect(user.transactions.count).to eq 1
      expect(user.transactions.last.type).to eq "sell"
    end
  end

  describe "Post #top_up" do
    it "should add the top_up value to cash amount" do
      top_up_amount = 10.0
      prev_amount = user.cash.amount

      post "/api/v1/transactions/top_up", params: { amount: top_up_amount, access_token: token }
      expect_status(:created)
      expect(user.cash.reload.amount).to eq prev_amount + top_up_amount
      expect(user.transactions.last.type).to eq "top_up"
    end
  end

  describe "Post #withdraw" do
    it "should deduct withdraw amount from cash amount" do
      withdraw_amount = 10.0
      user.cash.update_columns amount: withdraw_amount
      prev_amount = user.cash.amount

      post "/api/v1/transactions/withdraw", params: { cash_amount: withdraw_amount, access_token: token }
      expect_status(:created)
      expect(user.cash.reload.amount).to eq prev_amount - withdraw_amount
      expect(user.transactions.last.type).to eq "withdraw"
    end
  end
end
