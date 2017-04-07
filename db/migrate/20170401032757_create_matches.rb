class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.integer :available_quantity
      t.integer :max_quantity
      t.references :rent, foreign_key: true
    end
  end
end
