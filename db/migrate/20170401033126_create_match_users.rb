class CreateMatchUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :match_users do |t|
      t.references :match, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :quantity, default: 1
    end
  end
end
