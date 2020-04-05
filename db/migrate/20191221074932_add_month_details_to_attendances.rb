class AddMonthDetailsToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :month_enum, :integer
    add_column :attendances, :month_request_change, :boolean
  end
end
