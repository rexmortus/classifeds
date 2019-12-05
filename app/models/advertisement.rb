class Advertisement < ApplicationRecord

  include AlgoliaSearch

  algoliasearch do
    attributes :title, :body, :location, :created_at, :expires_at, :for, :category_name, :emoji
    geoloc :latitude, :longitude
    add_attribute :subcategory_name do
      category_name + " > " + subcategory_name
    end
  end

  belongs_to :user
  has_many :emoji_react

  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?

  enum category: Rails.application.config.classifeds_categories

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




end
