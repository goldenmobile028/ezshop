class Item < ApplicationRecord

has_one :item_favorite

  mount_uploader :thumbnail, ImageUploader

  def by_json
    {itemId: self.id.to_s, storeId: self.store_id, thumb_url: self.thumbnail.url,
     name: self.name, latitude: self.latitude, longitude: self.longitude,
     latitudeDelta: self.latitudeDelta, longitudeDelta: self.longitudeDelta,
     favorite: self.item_favorite.present? ? self.item_favorite.favorite.to_s : "0"}
  end

end
