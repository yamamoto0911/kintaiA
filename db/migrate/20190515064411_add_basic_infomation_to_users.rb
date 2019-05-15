class AddBasicInfomationToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :basic_start_time, :datetime, default: Time.zone.parse("2019/02/20 09:00")
    add_column :users, :basic_finish_time, :datetime, default: Time.zone.parse("2019/02/20 18:00")
  end
end
