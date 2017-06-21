class CreateStores < ActiveRecord::Migration[5.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :email
      t.string :address
      t.string :city
      t.string :zip
      t.float :latitude
      t.float :longitude
      t.string :thumb_url

      t.timestamps
    end
  end
end
