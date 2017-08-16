class Beacon < ApplicationRecord

  def by_json
    {beaconId: self.id.to_s, storeId: self.store_id.to_s, uuid: self.uuid,
     major: self.major, minor: self.minor, identifier: self.identifier,
     name: self.name, isEnabled: self.is_enabled}
  end

end
