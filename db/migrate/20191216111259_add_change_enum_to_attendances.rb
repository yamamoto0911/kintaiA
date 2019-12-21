class AddChangeEnumToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :change_enum, :integer
  end
end
