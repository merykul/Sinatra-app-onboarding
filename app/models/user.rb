class User < ActiveRecord::Base
  has_secure_password
  validates :username, presence: true, uniqueness: true, length: { within: 4..20, message: 'username length should be 4-20 symbols' }
  validates :first_name, presence: true
  validates :second_name, presence: true
  validates :password, presence: true, length: { within: 6..15, message: 'password must have length from 6 to 15 sym.' }
  # validates :password_validation

  # def password_validation
  #   unless password.match?(/\A(?=.*[a-zA-Z])(?=.*\d)(?=.*\W)/)
  #     errors.add(:password, "must include at least one letter, one digit, and one symbol")
  #   end
  # end
end
