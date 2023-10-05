require_relative '../../app/models/records'
require_relative '../../app/models/user'
require_relative '../../app/models/city'

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    second_name { Faker::Name.last_name }
    username { Faker::Internet.unique.username }
    password { 'Test123456!' }
    password_confirmation { 'Test123456!' }
  end
end
