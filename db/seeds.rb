require 'faker'
require_relative '../app/models/user'
require_relative '../app/models/records'

puts '🌱 Seeding data...'
puts '🌱 Generating TestUser for you...'

User.create!(password: 'Test123456!', password_confirmation: 'Test123456!', username: 'TestUser',
             first_name: 'Mariia',
             second_name: 'Tester',
             role: 0,
             password_status: 1)

User.create!(password: 'Test123456!', password_confirmation: 'Test123456!', username: 'TestAdmin',
             first_name: 'Admin',
             second_name: 'Tester',
             role: 1,
             password_status: 1)

puts '🌱 Generating random users...'

3.times do
  password = Faker::Alphanumeric.alphanumeric(number: 10)
  username = Faker::Internet.unique.username(specifier: "#{Faker::Name.unique.first_name}_#{Faker::Name.unique.last_name}")
  first_name = Faker::Name.unique.name
  second_name = Faker::Name.last_name
  password_status = 1
  User.create(password: password, username: username, first_name: first_name, second_name: second_name, password_status: password_status)
end

puts '🌱 Generating random Records...'
10.times do
  first_name = Faker::Name.unique.name
  second_name = Faker::Name.last_name
  city = Faker::Address.city
  date_of_birth = Faker::Date.birthday
  user_id = 1
  Records.create(first_name: first_name,
                 second_name: second_name,
                 city: city,
                 date_of_birth: date_of_birth,
                 user_id: user_id)
end

puts '🌱 Generating records with Ivano-Frankivsk as a city'
3.times do
  first_name = Faker::Name.unique.name
  second_name = Faker::Name.last_name
  city = 'Ivano-Frankivsk'
  date_of_birth = Faker::Date.birthday
  user_id = 1
  Records.create(first_name: first_name,
                 second_name: second_name,
                 city: city,
                 date_of_birth: date_of_birth,
                 user_id: user_id)
end

puts '✅ Done'
