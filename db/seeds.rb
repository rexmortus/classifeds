# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all
User.create!(email: 'admin@classifeds.aus.party', username: 'admin', password: 'topsecret', password_confirmation: 'topsecret', location: 'Melbourne, Australia')
User.create!(email: 'rexmortus@classifeds.aus.party', username: 'rexmortus', password: 'topsecret', password_confirmation: 'topsecret', location: 'Seattle, Washington')
