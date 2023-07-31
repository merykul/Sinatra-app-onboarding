require 'faker'
require_relative '../models/user.rb'
require_relative '../models/records'

puts "🌱 Seeding data..."
puts "🌱 Generating TestUser for you..."

User.create!(password: 'Test123456!', username: 'TestUser', first_name: 'Mariia', second_name: 'Tester')

puts"🌱 Generating random users..."

3.times do
  password = Faker::Alphanumeric.alphanumeric(number: 10)
  username = Faker::Internet.unique.username(specifier: "#{Faker::Name.unique.first_name}_#{Faker::Name.unique.last_name}")
  first_name = Faker::Name.unique.name
  second_name = Faker::Name.last_name
  User.create(password: password, username: username, first_name: first_name, second_name: second_name)
end

puts"🌱 Generating random Records..."
10.times do
  first_name = Faker::Name.unique.name
  second_name = Faker::Name.last_name
  city = Faker::Address.city
  date_of_birth = Faker::Date.birthday
  Records.create(first_name: first_name, second_name: second_name, city: city, date_of_birth: date_of_birth)
end

puts "✅ Done"
