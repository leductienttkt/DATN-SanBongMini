class CreateMiniPitches < ActiveRecord::Migration[5.0]
  def change
    create_table :mini_pitches do |t|
      t.string :name
      t.text :description
      t.float :price
      t.string :image
      t.integer :status, default: 0
      t.integer :pitch_type
      t.time :start_hour
      t.time :end_hour
      t.references :pitch, foreign_key: true
      t.references :user, foreign_key: true
      

      t.timestamps
    end
    add_index :mini_pitches, :name
    add_index :mini_pitches, :pitch_type
  end
end
