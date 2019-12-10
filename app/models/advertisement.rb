class Advertisement < ApplicationRecord

  include AlgoliaSearch

  algoliasearch do
    attributes :title, :body, :location, :created_at, :expires_at, :for, :category_name, :emoji
    geoloc :latitude, :longitude
    add_attribute :subcategory_name do
      category_name + " > " + subcategory_name
    end
    add_attribute :cover_image do
      if self.images.attached?
        Rails.application.routes.url_helpers.rails_blob_path(self.images.first, only_path: true)
      else
        "https://picsum.photos/1024/768?random=#{self.title}-1"
      end
    end
  end

  # Relationships
  belongs_to :user
  has_many :emoji_react
  has_many_attached :images

  # Geocoder
  geocoded_by :location

  # View Counter
  acts_as_punchable

  # Event hooks
  after_validation :geocode, if: :will_save_change_to_location?

  # Enums
  enum category: Rails.application.config.classifeds_categories

  def category_subcategory
    "#{self.category_name} > #{self.subcategory_name}"
  end

  def _geoloc
    self.geocode
  end

  def grouped_emoji
    self.emoji_react.inject(Hash.new(0)) do |accumulator, advertisement|
      accumulator[advertisement.emoji] += 1 ; accumulator
    end.sort_by {|_key, value| value}.reverse
  end

  def self.categories_as_form_collection
    self.categories.map.each_with_index do | (category, subcategories), category_id|
      values = subcategories.map.each_with_index do |subcategory, subcategory_id|
        [subcategory, [category, subcategory]]
      end
      [category, values]
    end
  end

  def self.categories_as_navbar_collection
    self.categories.map.each_with_index do | (category, subcategories), category_id|
      values = subcategories.map.each_with_index do |subcategory, subcategory_id|
        [subcategory, [category_id, subcategory_id]]
      end
      [category, values]
    end
  end

  def self.categories_as_checkbox_collection
    values = []
    self.categories.each do |category|

      title = category.first
      subcategories = category.last
      values.push(title)
      subcategories.each do |subcategory|
        values.push("#{title} > #{subcategory}")
      end


    end
    return values
  end

end
