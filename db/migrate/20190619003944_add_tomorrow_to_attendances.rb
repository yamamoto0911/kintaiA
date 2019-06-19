class AddTomorrowToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overwork_tomorrow, :boolean, default: false
  end
end
