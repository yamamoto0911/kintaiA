class AddOverworkRequestChangeAToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overwork_request_change, :boolean, default: false
  end
end
