class API < Grape::API
  prefix 'api'
  version 'v1'
  format :json

  # load remaining API endpoints
  mount Endpoints::Users
  mount Endpoints::Stores
  mount Endpoints::Items
  mount Endpoints::Beacons
end
