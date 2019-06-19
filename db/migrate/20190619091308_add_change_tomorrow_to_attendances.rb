class AddChangeTomorrowToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :change_tomorrow, :boolean, default: false
  end
end
