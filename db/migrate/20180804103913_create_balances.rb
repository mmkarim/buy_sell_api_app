class CreateBalances < ActiveRecord::Migration[5.0]
  def change
    create_table :balances do |t|
      t.references :user, foreign_key: true
      t.float :amount, default: 0.0
      t.string :type

      t.timestamps
    end
  end
end
