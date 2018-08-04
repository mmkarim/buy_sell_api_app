class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :type, :asset, :amount, :txref
end
