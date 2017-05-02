class CreatePromotions < ActiveRecord::Migration[5.0]
  def change
    create_table :promotions do |t|
      t.date :start_date
      t.date :end_date
      t.text :content
      t.references :pitch, foreign_key: true

      t.timestamps
      
    end
  end
end
