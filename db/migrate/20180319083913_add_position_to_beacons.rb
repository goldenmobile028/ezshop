class AddPositionToBeacons < ActiveRecord::Migration[5.0]
  def change
    add_column :beacons, :xpos, :float
    add_column :beacons, :ypos, :float
    add_column :beacons, :is_boundary, :boolean
  end
end
