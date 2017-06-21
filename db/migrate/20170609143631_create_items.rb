class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.string :thumbnail
      t.string :store_id

      t.timestamps
    end
  end
end
