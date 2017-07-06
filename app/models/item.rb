class Item < ApplicationRecord

has_many :item_favorites

  mount_uploader :thumbnail, ImageUploader

  def by_json
    {itemId: self.id.to_s, storeId: self.store_id, thumb_url: self.thumbnail.url,
     name: self.name, latitude: self.latitude, longitude: self.longitude,
     latitudeDelta: self.latitudeDelta, longitudeDelta: self.longitudeDelta,
     favorite: "0"}
  end

  def by_json_user(user_id)
    item = self.item_favorites.find_by(user_id: user_id)
    {itemId: self.id.to_s, storeId: self.store_id, thumb_url: self.thumbnail.url,
     name: self.name, latitude: self.latitude, longitude: self.longitude,
     latitudeDelta: self.latitudeDelta, longitudeDelta: self.longitudeDelta,
     favorite: item.present? ? item.favorite.to_s : "0"}
  end

end
