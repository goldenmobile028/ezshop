class Store < ApplicationRecord
  def by_json
    {email: self.email, storeId: self.id, name: self.name, address: self.address,
     city: self.city, zip: self.zip, longitude: self.longitude, latitude: self.latitude}
  end
end
