class CreateStoreFavorites < ActiveRecord::Migration[5.0]
  def change
    create_table :store_favorites do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :store, foreign_key: true
      t.boolean :favorite, default: false

      t.timestamps
    end
  end
end
