class User < ApplicationRecord
  has_many :balances, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_one :gold, dependent: :destroy
  has_one :cash, dependent: :destroy

  devise :database_authenticatable, :registerable

  enum currency: [:myr, :thb]

  after_create :create_cash!, :create_gold!
end
