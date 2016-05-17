class CreateMeasurements < ActiveRecord::Migration[5.0]
  def change
    create_table :measurements do |t|
      t.references :series, null: false
      t.references :snapshot, null: false
      t.datetime :created_at, null: false
      t.decimal :value, null: false
    end
  end
end
