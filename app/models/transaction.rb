class Transaction < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :user

  enum status: [:approved, :failed, :rejected]
  enum asset: [:gold, :cash]
  enum type: [:buy, :sell, :top_up, :withdraw]

  validates :status, :asset, :amount, :type, :txref, presence: true
  validates :txref, uniqueness: true

  before_validation :generate_txref!

  private
  def generate_txref!
    self.txref = loop do
      txref = SecureRandom.urlsafe_base64
      break txref unless Transaction.exists?(txref: txref)
    end
  end
end
