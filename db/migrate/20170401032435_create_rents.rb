class CreateRents < ActiveRecord::Migration[5.0]
  def change
    create_table :rents do |t|
      t.time :start_hour
      t.time :end_hour
      t.date :date
      t.integer :status, default: 0
      t.references :mini_pitch, foreign_key: true
      t.references :user, foreign_key: true
    end
  end
end
