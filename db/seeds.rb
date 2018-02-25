# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

role = ["standard", "admin", "premium"]

5.times do

  User.create(
    name: Faker::RuPaul.unique.queen,
    email: Faker::Internet.unique.email,
    role: role.sample,
    password: "111111",
    confirmed_at: Time.now
  )

end

admin = User.create!(
  name:     'Admin User',
  email:    'admin@example.com',
  role:     'admin',
  password: '111111',
  confirmed_at: Time.now
)

standard = User.create!(
  name:     'Member User',
  email:    'member@example.com',
  role:     'standard',
  password: '111111',
  confirmed_at: Time.now
)

premium = User.create!(
  name:     'Moderator User',
  email:    'moderator@example.com',
  role:     'premium',
  password: '111111',
  confirmed_at: Time.now
)

users = User.all

25.times do

  user = users.sample
  private = user.role == "standard" ? false : [true,false].sample

  wiki = Wiki.create!(
  title:  Faker::Company.bs,
  body:   Faker::TheFreshPrinceOfBelAir.quote,
  user: user,
  private: private
)
  wiki.update_attribute(:created_at, rand(10.minutes .. 1.year).ago)

end




puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
