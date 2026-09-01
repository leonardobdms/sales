class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.string :customer_name, null: false
      t.string :status, null: false, default: 'pending'
      t.integer :total_cents, null: false, default: 0
      t.string :address, null: false

      t.timestamps
    end
  end
end
