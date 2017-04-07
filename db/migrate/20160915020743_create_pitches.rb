class CreatePitches < ActiveRecord::Migration[5.0]
  def change
    create_table :pitches do |t|
      t.string :name
      t.text :description
      t.integer :status, default: 0
      t.string :cover_image
      t.string :avatar
      t.float :averate_rating
      t.time :time_auto_reject, default: "00:30:00"
      t.references :owner

      t.timestamps
    end
  end
end
