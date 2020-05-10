class AddChangeApprovalDateToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :change_approval_date, :date
  end
end
