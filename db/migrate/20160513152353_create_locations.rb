class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.string :text_id, null: false
      t.string :name, null: false
      t.decimal :latitude
      t.decimal :longitude
      t.decimal :elevation
    end
    add_index :locations, :text_id, unique: true
  end
end
