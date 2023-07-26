class RenamePeopleRecordsToRecords < ActiveRecord::Migration[6.1]
  def change
    rename_table :people_records, :records
  end
end
