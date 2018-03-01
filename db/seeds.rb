# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

role = ["standard", "premium"]

20.times do

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
  name:     'Standard User',
  email:    'standard@example.com',
  role:     'standard',
  password: '111111',
  confirmed_at: Time.now
)

premium = User.create!(
  name:     'Premium User',
  email:    'premium@example.com',
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
  body:   (Faker::TheFreshPrinceOfBelAir.quote + "........."),
  user: user,
  private: private
)
  wiki.update_attribute(:created_at, rand(10.minutes .. 1.year).ago)

end

wikis = Wiki.all

15.times do

  pick = false

  until pick == true
    wiki = wikis.sample
    user = users.sample


    (wiki.private && (wiki.user != user) && (user.role != 'admin') && (Collaborator.pluck(:user_id).include?(user.id) == false) ) ? pick = true : false
  end

  Collaborator.create( user: user, wiki: wiki )

end

Amount.create( price: 1500 )


puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
puts "#{Collaborator.count} collaborators created"
