module Endpoints
  class Beacons < Grape::API

    resource :beacons do

      # Items API test
      # /api/v1/beacons/ping
      # results  'huawan'
      get :ping do
        { :ping => 'huawan' }
      end

      # Get Beacons
      # GET: /api/v1/beacons/get_beacons
      # parameters:
      #   store_id:       String *required
      #   page_number:    Integer *optional

      # results:
      #   return beacons list
      get :get_beacons do
        beacons = Beacon.where(store_id: params[:store_id])
        if beacons.present?
          {status: 1, data: beacons.map{|beacon| beacon.by_json}}
        else
          {status: 0, data: {error: 'Can\'t find your beacons'}}
        end
      end

      # Search Beacons
      # GET: /api/v1/beacons/search_beacons
      # parameters:
      #   store_id:       String *optional
      #   user_id:        String *optional
      #   identifier:     String *optional
      #   uuid:           String *required

      # results:
      #   return beacons list
      get :search_beacons do
        if params[:store_id].present?
          beacons = Beacon.where(store_id: params[:store_id]).
                       where("uuid LIKE ?", "%#{params[:uuid]}%")
        else
          beacons = Beacon.where("uuid LIKE ?", "%#{params[:uuid]}%")
        end
        if beacons.present?
          if params[:identifier].present?
            beacons = beacons.where("identifier LIKE ?", "%#{params[:identifier]}%")
            {status: 1, data: beacons.map{|beacon| beacon.by_json}}
          else
            {status: 1, data: beacons.map{|beacon| beacon.by_json}}
          end
        else
          {status: 0, data: {error: 'Can\'t find your beacons'}}
        end
      end


      # Add New Beacon
      # GET: /api/v1/beacons/add_beacon
      # parameters:
      #   uuid:           String *required
      #   name:           String *required
      #   store_id:       String *required
      #   identifier:     String *required
      #   major:          Integer *required
      #   minor:          Integer *required

      # results:
      #   return beacon data
      post :add_beacon do
        beacon = Beacon.new(uuid: params[:uuid], store_id: params[:store_id],
                        identifier: params[:identifier], major: params[:major],
                        minor: params[:minor], name: params[:name],
                        is_enabled: true)
        if beacon.save()
          {status: 1, data: beacon.by_json}
        else
          {status: 0, data: {error: beacon.errors.messages}}
        end
      end


      # Update Beacon
      # GET: /api/v1/beacons/update_beacon
      # parameters:
      #   beacon_id:      String *required
      #   uuid:           String *required
      #   name:           String *required
      #   store_id:       String *required
      #   identifier:     String *required
      #   major:          Integer *required
      #   minor:          Integer *required

      # results:
      #   return beacon data
      post :update_beacon do
        beacon = Beacon.find_by(id: params[:beacon_id])
        if beacon.present?
          beacon.update_attributes(name: params[:name], uuid: params[:uuid],
                  identifier: params[:identifier], major: params[:major],
                  minor: params[:minor])
          {status: 1, data: beacon.by_json}
        else
          {status: 0, data: {error: beacon.errors.messages}}
        end
      end


      # Delete Beacon
      # DELETE: /api/v1/items/delete_beacon
      # parameters:
      #   beacon_id:      String *required
      #   store_id:       String *required
      #   user_id:        String *required

      # results:
      #   return success
      delete :delete_beacon do
        beacon = Beacon.find_by(id: params[:beacon_id])
        if beacon.present?
          beacon.destroy
          {status: 1, data: {success: 'Deleted your beacon'}}
        else
          {status: 0, data: {error: 'Can\'t find your beacon'}}
        end
      end


      # Enable/Disable Beacon
      # DELETE: /api/v1/beacons/set_enable
      # parameters:
      #   beacon_id:      String *required
      #   store_id:       String *required
      #   is_enabled:     Boolean *required

      # results:
      #   return success
      post :set_enable do
        beacon = Beacon.find_by(id: params[:beacon_id])
        if beacon.present?
          beacon.update_attributes(is_enabled: params[:is_enabled])
          {status: 1, data: {success: beacon.by_json}}
        else
          {status: 0, data: {error: 'Can\'t find your beacon'}}
        end
      end


      # Enable/Disable Beacons
      # DELETE: /api/v1/beacons/set_beacons_enable
      # parameters:
      #   beacon_ids:     String *required
      #   store_id:       String *required
      #   is_enableds:    Boolean *required

      # results:
      #   return success
      post :set_beacons_enable do
        beacon = Beacon.find_by(id: params[:beacon_id])
        if beacon.present?
          beacon.update_attributes(is_enabled: params[:is_enabled])
          {status: 1, data: {success: beacon.by_json}}
        else
          {status: 0, data: {error: 'Can\'t find your beacon'}}
        end
      end


    end
  end
end
