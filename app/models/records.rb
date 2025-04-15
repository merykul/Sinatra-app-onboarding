# frozen_string_literal: true

require_relative 'city'

class Records < ActiveRecord::Base
  belongs_to :user, foreign_key: :user_id
  validates :first_name, presence: true
  validates :second_name, presence: true
  validates :city, presence: true, length: { within: 1..100, message: 'length should be between 1 and 100 symbols' }
  after_save :update_city_records_count
  after_destroy :update_city_records_count
  after_update :update_city_records_count

  private

  def update_city_records_count
    city = City.find_or_create_by(city: self.city)
    # used method from city model:
    city.update_records_count
  end
end
