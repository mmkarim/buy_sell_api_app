class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.float :amount, null: false
      t.integer :type, null: false
      t.integer :status, default: "approved", null: false
      t.integer :asset, null: false
      t.string :txref, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :transactions, :txref, unique: true
  end
end
