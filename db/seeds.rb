require 'open-uri'

User.destroy_all
user = User.create!(email: 'admin@classifeds.aus.party', username: 'admin', password: 'topsecret', password_confirmation: 'topsecret', location: Rails.application.config.classifeds_default_location)

Advertisement.destroy_all

# 10 books
puts 'Creating 10 books'
10.times do

  ad = Advertisement.new(
    user: user,
    title: Faker::Book.title,
    body: Faker::Lorem.paragraphs(number: 3).join(' '),
    emoji: Emoji.all.sample.raw,
    for: 'Sale',
    category_name: 'Books',
    subcategory_name: 'Fiction',
    location: Rails.application.config.classifeds_default_location
  )

  url = URI.escape("https://picsum.photos/seed/#{ad.title}/#{rand(400...600)}/#{rand(600...800)}")

  ad.images.attach(
    io: open(url),
    filename: "#{ad.title}.jpg",
    content_type: 'image/jpeg',
    identify: false
  )

  ad.save

end

# 10 appliances
puts 'Creating 10 appliances'
10.times do

  ad = Advertisement.new(
    user: user,
    title: Faker::Appliance.equipment,
    body: Faker::Lorem.paragraphs(number: 3).join(' '),
    emoji: Emoji.all.sample.raw,
    for: 'Sale',
    category_name: 'Tools',
    subcategory_name: 'Fiction',
    location: Rails.application.config.classifeds_default_location
  )

  url = URI.escape("https://picsum.photos/seed/#{ad.title}/#{rand(400...600)}/#{rand(600...800)}")

  ad.images.attach(
    io: open(url),
    filename: "#{ad.title}.jpg",
    content_type: 'image/jpeg',
    identify: false
  )

  ad.save

end
