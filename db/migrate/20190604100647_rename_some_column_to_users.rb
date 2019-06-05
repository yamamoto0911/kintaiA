class RenameSomeColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :department, :affiliation
    rename_column :users, :code, :employee_number
    rename_column :users, :basic_time, :basic_work_time
    rename_column :users, :basic_start_time, :designated_work_start_time
    rename_column :users, :basic_finish_time, :designated_work_end_time
  end
end

