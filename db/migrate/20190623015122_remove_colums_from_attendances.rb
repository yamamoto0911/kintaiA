class RemoveColumsFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :superior_name, :string
    remove_column :attendances, :superior_id, :integer
  end
end
