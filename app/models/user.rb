class User < ActiveRecord::Base
  has_secure_password
  has_many :records, foreign_key: :user_id
  enum role: { user: 0, admin: 1 }
  enum password_status: { temporary: 0, permanent: 1 }
  validates :username, presence: true, uniqueness: true, length: { within: 4..20, message: 'username length should be 4-20 symbols' }, on: :create
  validates :first_name, presence: true
  validates :second_name, presence: true
  validates :password, presence: true, length: { within: 6..15, message: 'password must have length from 6 to 15 sym.' }, allow_nil: true
  validates :password_confirmation, presence: true, allow_nil: true

  def temporary_password?
    password_status == 'temporary'
  end

  def delete_with_records(user, records)
    ActiveRecord::Base.transaction do
      records.destroy_all
      user.delete
    end
  end

  def delete_with_records_transfer(user, records, user_to_accept)
    ActiveRecord::Base.transaction do
      records.update(user_id: user_to_accept)
      user.destroy
    end
  end
end
