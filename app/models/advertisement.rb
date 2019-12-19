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
  after_validation :display_geocode, if: :will_save_change_to_location?

  # Enums
  enum category: Rails.application.config.classifeds_categories

  # Class method for creating form collection
  def self.categories_as_form_collection
    self.categories.map.each_with_index do | (category, subcategories), category_id|
      values = subcategories.map.each_with_index do |subcategory, subcategory_id|
        [subcategory, [category, subcategory]]
      end
      [category, values]
    end
  end

  # Class method for creating navbar collection
  def self.categories_as_navbar_collection
    self.categories.map.each_with_index do | (category, subcategories), category_id|
      values = subcategories.map.each_with_index do |subcategory, subcategory_id|
        [subcategory, [category_id, subcategory_id]]
      end
      [category, values]
    end
  end

  # Class method for creating category checkbox collection
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

  # Return a string like "Books > Fiction"
  def category_subcategory
    "#{self.category_name} > #{self.subcategory_name}"
  end

  # Return all the emoji reacts, grouped by amount
  def grouped_emoji
    self.emoji_react.inject(Hash.new(0)) do |accumulator, advertisement|
      accumulator[advertisement.emoji] += 1 ; accumulator
    end.sort_by {|_key, value| value}.reverse
  end

  # Return the advertisement as a mapbox marker
  def as_marker
    {
      emoji: self.emoji,
      coordinates: self.display_geocode,
      title: self.title,
      id: self.id
    }
  end

  # Generate a "display geocode"
  def display_geocode
    if self.display_latitude.nil? && self.display_longitude.nil?

      # Compute a scatter
      r = 0.008086253369272238
      y0 = self.geocode[0]
      x0 = self.geocode[1]
      u = rand
      v = rand
      w = r * Math.sqrt(u)
      t = 2 * Math::PI * v
      x = w * Math.cos(t)
      y1 = w * Math.sin(t)
      x1 = x / Math.cos(y0)

      newY = y0 + y1
      newX = x0 + x1

      puts "---"
      puts "#{geocode[0]}"
      puts "#{newY}"
      puts "---"

      self.display_latitude = newY
      self.display_longitude = newX
      self.save!
    end
    [self.display_latitude, self.display_longitude]
  end

end
