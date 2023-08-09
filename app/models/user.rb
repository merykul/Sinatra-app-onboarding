class User < ActiveRecord::Base
  has_secure_password
  has_many :records, foreign_key: :user_id
  enum role: { user: 0, admin: 1 }
  enum password_status: { temporary: 0, permanent: 1 }
  validates :username, presence: true, uniqueness: true, length: { within: 4..20, message: 'username length should be 4-20 symbols' }, on: :create
  validates :first_name, presence: true
  validates :second_name, presence: true
  validates :password, presence: true, length: { within: 6..15, message: 'password must have length from 6 to 15 sym.' }
  validates :password_confirmation, presence: true

  def temporary_password?
    password_status == 'temporary'
  end
end
