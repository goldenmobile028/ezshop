class AddBeaconIdToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :beacon_id, :string
  end
end
