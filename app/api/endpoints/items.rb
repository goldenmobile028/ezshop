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
          {status: 0, data: {error: 'Can\'t find your items'}}
        end
      end

      # Search Items
      # GET: /api/v1/items/search_items
      # parameters:
      #   store_id:       String *optional
      #   user_id:        String *required
      #   search_key:     String *required
      #   page_number:    Integer *required

      # results:
      #   return items list
      get :search_items do
        if params[:store_id].present?
          items = Item.where(store_id: params[:store_id]).
                       where("lower(name) LIKE ?", "%#{params[:search_key].downcase}%")
        else
          items = Item.where("lower(name) LIKE ?", "%#{params[:search_key].downcase}%")
        end
        if items.present?
          if params[:user_id].present?
            {status: 1, data: items.map{|item| item.by_json_user(params[:user_id])}}
          else
            {status: 1, data: items.map{|item| item.by_json}}
          end
        else
          {status: 0, data: {error: 'Can\'t find your items'}}
        end
      end


      # Search Favorites
      # GET: /api/v1/items/search_favorites
      # parameters:
      #   user_id:        String *required
      #   search_key:     String *optional
      #   page_number:    Integer *required

      # results:
      #   return items list
      get :search_favorites do
        user = User.find(params[:user_id])
        favorites = user.item_favorites.favorites
        if params[:search_key].present?
          favorites = favorites.joins(:item).where("lower(items.name) LIKE ?", "%#{params[:search_key].downcase}%")
        end
        if favorites.present?
          if params[:user_id].present?
            {status: 1, data: favorites.map{|item| item.item.by_json_user(params[:user_id])}}
          else
            {status: 1, data: favorites.map{|item| item.item.by_json}}
          end
        else
          {status: 0, data: {error: 'Can\'t find your items'}}
        end
      end

      # Add New Item
      # GET: /api/v1/items/add_item
      # parameters:
      #   name:           String *required
      #   store_id:       String *required
      #   thumbnail:      String *optional
      #   longitude:      Float *required
      #   latitude:       Float *required
      #   longitudeDelta: Float *required
      #   latitudeDelta:  Float *required
      #   location:       String *required
      #   beacon_id:      String *required

      # results:
      #   return item data
      post :add_item do
        item = Item.new(name: params[:name], store_id: params[:store_id],
                        longitude: params[:longitude], latitude: params[:latitude],
                        longitudeDelta: params[:longitudeDelta],
                        latitudeDelta: params[:latitudeDelta], location: params[:location],
                        beacon_id: params[:beacon_id])
        # item.avatar = params[:thumbnail]
        if item.save()
          # item.avatar.url # => '/url/to/file.png'
          # item.avatar.current_path # => 'path/to/file.png'
          # item.avatar_identifier # => 'file.png'
          if params[:thumbnail].present?
            item.thumbnail = params[:thumbnail]
            item.save()
          end
          {status: 1, data: item.by_json}
        else
          {status: 0, data: {error: item.errors.messages}}
        end
      end


      # Update Item
      # POST: /api/v1/items/update_item
      # parameters:
      #   name:           String *required
      #   item_id:        String *required
      #   store_id:       String *required
      #   thumbnail:      String *optional
      #   longitude:      Float *required
      #   latitude:       Float *required
      #   longitudeDelta: Float *required
      #   latitudeDelta:  Float *required
      #   location:       String *required
      #   beacon_id:      String *required

      # results:
      #   return item data
      post :update_item do
        item = Item.find_by(id: params[:item_id])
        if item.present?
          item.update_attributes(name: params[:name], longitude: params[:longitude],
                                 latitude: params[:latitude], longitudeDelta: params[:longitudeDelta],
                                 latitudeDelta: params[:latitudeDelta], location: params[:location],
                                 beacon_id: params[:beacon_id])
          if params[:thumbnail].present?
            item.thumbnail = params[:thumbnail]
            item.save()
          end
          {status: 1, data: item.by_json}
        else
          {status: 0, data: {error: item.errors.messages}}
        end
      end


      # Delete Item
      # DELETE: /api/v1/items/delete_item
      # parameters:
      #   item_id:        String *required
      #   store_id:       String *required
      #   user_id:      String *required

      # results:
      #   return success
      delete :delete_item do
        item = Item.find_by(id: params[:item_id])
        if item.present?
          item.destroy
          {status: 1, data: {success: 'Deleted your item'}}
        else
          {status: 0, data: {error: 'Can\'t find your item'}}
        end
      end


      # Favorite Item
      # GET: /api/v1/items/favorite_item
      # parameters:
      #   user_id:        String *required
      #   item_ids:        String *required
      #   favorite:       Boolean *required

      # results:
      #   return item data
      get :favorite_item do
        user = User.find(params[:user_id])
        if user.present?
          params[:item_ids].split(',').each do |item_id|
            favorite = ItemFavorite.find_by(user_id: params[:user_id], item_id: item_id)
            if favorite.present?
              favorite.update_attributes(favorite: params[:favorite])
            else
              favorite = user.item_favorites.new(item_id: item_id, favorite: params[:favorite])
              if favorite.save()
                p 'Favorited item'
              else
                return {status: 0, data: {error: favorite.errors.messages}}
              end
            end
          end
          {status: 1, data: {data: 'Favorited item(s)'}}
        else
          {status: 0, data: {error: 'User does not exist.'}}
        end
      end

    end
  end
end
