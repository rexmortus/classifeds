class Watchlist < ApplicationRecord

  # Relationships
  belongs_to :user

  # Geocoder
  geocoded_by :location

  # Event hooks
  after_validation :geocode, if: :will_save_change_to_location?

end
