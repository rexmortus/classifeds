class Advertisement < ApplicationRecord

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

  def grouped_emoji
    self.emoji_react.inject(Hash.new(0)) do |accumulator, advertisement|
      accumulator[advertisement.emoji] += 1 ; accumulator
    end.sort_by {|_key, value| value}.reverse
  end

  def as_marker
    {
      emoji: self.emoji,
      coordinates: self.geocode,
      title: self.title,
      id: self.id
    }
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
