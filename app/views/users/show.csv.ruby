require 'csv'
require "date"

CSV.generate do |csv|
  csv_column_names = %w(日付 出社 退社 備考 残業終了予定時間 業務内容)
  csv << csv_column_names
  @user.attendances.each do |attendance|
    column_values = [
      attendance.worked_on,
      attendance.started_at,
      attendance.finished_at,
      attendance.note
    ]
    csv << column_values
  end
end