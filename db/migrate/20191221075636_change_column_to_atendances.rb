class ChangeColumnToAtendances < ActiveRecord::Migration[5.1]
  def change
    change_column :attendances, :month_request_change, :boolean, default: false
  end
end
