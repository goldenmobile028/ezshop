class Item < ApplicationRecord

  mount_uploader :thumbnail, ImageUploader

  def by_json
    {itemId: self.id.to_s, storeId: self.store_id, thumb_url: self.thumbnail.url, name: self.name, latitude: self.latitude, longitude: self.longitude}
  end

end
