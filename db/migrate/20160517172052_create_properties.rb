class CreateProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :properties do |t|
      t.string :text_id, null: false
      t.string :name, null: false
      t.string :unit, null: false
    end
    add_index :properties, [:text_id, :unit], unique: true
  end
end
