class Beacon < ApplicationRecord

  def by_json
    {beaconId: self.id.to_s, storeId: self.store_id.to_s, uuid: self.uuid,
     major: self.major, minor: self.minor, identifier: self.identifier,
     name: self.name, isEnabled: self.is_enabled ? self.is_enabled : true,
     xpos: self.xpos ? self.xpos : 0.0, ypos: self.ypos ? self.ypos : 0.0,
     isBoundary: self.is_boundary ? self.is_boundary : false}
  end

end
