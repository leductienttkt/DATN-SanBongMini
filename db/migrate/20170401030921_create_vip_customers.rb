class CreateVipCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :vip_customers do |t|
      t.integer :quantity, default: 1
      t.references :user, foreign_key: true
      t.references :pitch, foreign_key: true

      t.timestamps
    end
  end
end
