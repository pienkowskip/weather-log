class CreateSeries < ActiveRecord::Migration[5.0]
  def change
    create_table :series do |t|
      t.references :source, null: false
      t.references :location, null: false
      t.references :property, null: false
    end
    add_index :series, [:source_id, :location_id, :property_id], unique: true
  end
end
