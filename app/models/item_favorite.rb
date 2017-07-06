class ItemFavorite < ApplicationRecord
  belongs_to :user
  belongs_to :item

  scope :favorites, -> { where(favorite: true) }
  scope :unfavorites, -> { where(favorite: false) }

end
