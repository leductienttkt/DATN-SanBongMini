class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :details, null: false
      t.string :city
      t.float :latitude
      t.float :longitude
      t.string :postal_code
      t.string :street_address
      t.string :unit
      t.belongs_to :pitch, index: true

      t.timestamps
    end
  end
end
