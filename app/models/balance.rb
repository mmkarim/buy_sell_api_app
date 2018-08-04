class Balance < ApplicationRecord
  belongs_to :user

  validates :amount, numericality: { greater_than_or_equal_to: 0.0 }

  CASH_TO_GOLD_RATE = 0.1
  GOLD_TO_CASH_RATE = 10

  def deduct_amount! value
    return false if value > self.amount
    self.with_lock do
      self.amount -= value
      self.save!
    end
  end

  def add_amount! value
    self.with_lock do
      self.amount += value
      self.save!
    end
  end
end
