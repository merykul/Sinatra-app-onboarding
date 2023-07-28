require 'faker'
require_relative '../models/user.rb'

puts "🌱 Seeding data..."
puts "🌱 Generating TestUser for you..."

User.create!(password: 'test123456', username: 'TestUser', first_name: 'Mariia', second_name: 'Tester')

puts"🌱 Generating random users..."

3.times do
  password = Faker::Alphanumeric.alphanumeric(number: 10)
  username = Faker::Internet.unique.username(specifier: "#{Faker::Name.unique.first_name}_#{Faker::Name.unique.last_name}")
  first_name = Faker::Name.unique.name
  second_name = Faker::Name.last_name
  User.create(password: password, username: username, first_name: first_name, second_name: second_name)
end

puts "✅ Done"
