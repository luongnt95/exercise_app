# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(name:  "luong",
             email: "luong@gmail.com",
             activated: "activated",
             admin: true,
             password:              "123456",
             password_confirmation: "123456")

20.times do |n|
  name  = Faker::Name.name
  Category.create!(name: name,
          activated: "deactivated")
end

20.times do |n|
  name  = Faker::Name.name
  Product.create!(name: name,
  			  description: "It's so beautiful",
  			  price: 100.000,
  			  activated: "deactivated")
end

20.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
              email: email,
              password:              password,
              password_confirmation: password,
              activated: "deactivated",
              admin: false)
end