class CreateTables < ActiveRecord::Migration[7.1]
  def change
    create_table :tables do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.integer :capacity
      t.string :location

      t.timestamps
    end
  end
end
