class CreateSnapshots < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|
      direction.up { execute(<<-SQL) }
        CREATE TYPE snapshot_status AS ENUM ('created', 'fetched', 'parsed');
      SQL
      direction.down { execute(<<-SQL) }
        DROP TYPE snapshot_status;
      SQL
    end

    create_table :snapshots do |t|
      t.references :source, null: false
      t.references :location, null: false
      t.datetime :created_at, null: false
      t.column :status, :snapshot_status, null: false
      t.string :media_type
      t.binary :file
      t.text :error
    end
  end
end
