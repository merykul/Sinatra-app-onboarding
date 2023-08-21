require_relative '../controllers/controllers_helpers/user_helper'
require_relative '../controllers/application_controller'

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

  def delete_with_records_transfer_to_new(user, records, new_user_opts)
    error_messages = []

    ActiveRecord::Base.transaction do
      new_user = User.create(new_user_opts)
      if new_user.valid?
        new_user.save
        records.update(user_id: new_user.id)
        user.destroy
      else
        error_messages = new_user.errors.full_messages
        p "Error messages: #{error_messages}"
        raise ActiveRecord::Rollback, 'Error while user creation, check provided values'
      end
    end

    error_messages
  end
end
