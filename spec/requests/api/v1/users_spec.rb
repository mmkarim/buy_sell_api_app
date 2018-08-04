require "rails_helper"

describe "Users API" do
  describe "Get #balance" do
    let!(:user){ FactoryGirl.create :user }

    it "should return all balances" do
      token = Doorkeeper::AccessToken.create(resource_owner_id: user.id).token
      get "/api/v1/users/balance", params: { access_token: token }
      expect_status(:ok)
      expect_json_types "*", type: :string, amount: :float
      expect_json('0', type: "Cash", amount: 0.0)
      expect_json('1', type: "Gold", amount: 0.0)
    end
  end

  describe "Post #register" do
    it "should create a new user with proper value" do
      post "/api/v1/users/register", params: { name: "abc", password: "123123123", email: "mk@mail.com", currency: "myr" }
      expect_status(:created)
      expect(User.count).to eq 1
    end

    it "should give error response with wrong values" do
      post "/api/v1/users/register", params: { name: "abc", password: "123123123", email: "", currency: "xxx" }
      expect_status(500)
    end
  end

  describe "Post #log_in" do
    let!(:user){ FactoryGirl.create :user }
    it "should return access_token if login successful" do
      post "/api/v1/users/log_in", params: { email: user.email, password: user.password }
      expect_status(:created)
      expect_json_types(access_token: :string)
    end
  end
end
