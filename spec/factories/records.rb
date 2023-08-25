require_relative '../../app/models/records'

FactoryBot.define do
  factory :records do
    first_name { Faker::Name.first_name }
    second_name { Faker::Name.last_name }
    city { Faker::Address.city }
    date_of_birth { Faker::Date.birthday }
    user_id { 1 }
  end
end
