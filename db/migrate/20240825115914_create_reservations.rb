class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.references :table, null: false, foreign_key: true
      t.string :customer_name
      t.string :customer_email
      t.string :customer_phone
      t.datetime :reservation_date
      t.integer :party_size
      t.string :status
      t.string :confirmation_code

      t.timestamps
    end
  end
end
