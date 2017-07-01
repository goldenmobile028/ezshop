module Endpoints
  class Items < Grape::API

    resource :items do

      # Items API test
      # /api/v1/items/ping
      # results  'huawan'
      get :ping do
        { :ping => 'huawan' }
      end

      # Get Items
      # GET: /api/v1/items/get_items
      # parameters:
      #   email:          String *required
      #   store_id:       String *required
      #   page_number:    Integer *required

      # results:
      #   return items list
      get :get_items do
        items = Item.where(store_id: params[:store_id])
        if items.present?
          {status: 1, data: items.map{|item| item.by_json}}
        else
          {status: 0, data: {error: 'Cann\'t find your items'}}
        end
      end

      # Search Items
      # GET: /api/v1/items/search_items
      # parameters:
      #   store_id:       String *required
      #   page_number:    Integer *required

      # results:
      #   return items list
      get :get_items do
        items = Item.where(store_id: params[:store_id])
        if items.present?
          {status: 1, data: items.map{|item| item.by_json}}
        else
          {status: 0, data: {error: 'Cann\'t find your items'}}
        end
      end


      # Add New Item
      # GET: /api/v1/items/add_item
      # parameters:
      #   name:           String *required
      #   store_id:       String *required
      #   thumbnail:      String *required
      #   longitude:      Float *required
      #   latitude:       Float *required
      #   longitudeDelta: Float *required
      #   latitudeDelta:  Float *required

      # results:
      #   return item data
      post :add_item do
        item = Item.new(name: params[:name], store_id: params[:store_id], thumbnail: params[:thumbnail],
                          longitude: params[:longitude], latitude: params[:latitude],
                          longitudeDelta: params[:longitudeDelta], latitudeDelta: params[:latitudeDelta])
        # item.avatar = params[:thumbnail]
        if item.save()
          # item.avatar.url # => '/url/to/file.png'
          # item.avatar.current_path # => 'path/to/file.png'
          # item.avatar_identifier # => 'file.png'
          {status: 1, data: item.by_json}
        else
          {status: 0, data: {error: item.errors.messages}}
        end
      end

      # Update Item
      # GET: /api/v1/items/update_item
      # parameters:
      #   name:           String *required
      #   item_id         String *required
      #   store_id:       String *required
      #   thumbnail:      String *optional
      #   longitude:      Float *required
      #   latitude:       Float *required
      #   longitudeDelta: Float *required
      #   latitudeDelta:  Float *required

      # results:
      #   return item data
      post :update_item do
        item = Item.find_by(id: params[:item_id])
        if item.present?
          item.update_attributes(name: params[:name], longitude: params[:longitude],
                                 latitude: params[:latitude], longitudeDelta: params[:longitudeDelta],
                                 latitudeDelta: params[:latitudeDelta])
          if params[:thumbnail].present?
            item.thumbnail = params[:thumbnail]
            item.save()
          end
          {status: 1, data: item.by_json}
        else
          {status: 0, data: {error: item.errors.messages}}
        end
      end
    end
  end
end
