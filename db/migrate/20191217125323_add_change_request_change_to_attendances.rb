class AddChangeRequestChangeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :change_request_change, :boolean, default: false
  end
end
