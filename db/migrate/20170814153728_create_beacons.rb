class CreateBeacons < ActiveRecord::Migration[5.0]
  def change
    create_table :beacons do |t|
      t.string :uuid
      t.string :identifier
      t.integer :major
      t.integer :minor
      t.integer :store_id
      t.boolean :is_enabled
      t.string  :name

      t.timestamps
    end
  end
end
