class AddPrimaryAndForeignKeys < ActiveRecord::Migration[7.0]
  def change
    change_column :records, :user_id, :bigint
    add_foreign_key :records, :users, column: :user_id
  end
end
