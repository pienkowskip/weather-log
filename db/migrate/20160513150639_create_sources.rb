class CreateSources < ActiveRecord::Migration[5.0]
  def change
    create_table :sources do |t|
      t.string :text_id, null: false
      t.string :name, null: false
      t.json :config
    end
    add_index :sources, :text_id, unique: true
  end
end
