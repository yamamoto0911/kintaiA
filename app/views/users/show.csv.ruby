require 'csv'
require 'date'

CSV.generate do |csv|
  csv_column_names = %w(日付 出社 退社 備考 残業終了予定時間 業務内容)
  csv << csv_column_names
  @user.attendances.where(worked_on: @first_day..@last_day).each do |attendance|
    if attendance.started_at.present? && attendance.finished_at.present?
      column_values = [
        attendance.worked_on.to_s(:date),
        attendance.started_at.to_s(:time),
        attendance.finished_at.to_s(:time),
        attendance.note
      ]
      csv << column_values
    elsif attendance.started_at.present? && !attendance.finished_at.present?
      column_values = [
        attendance.worked_on.to_s(:date),
        attendance.started_at.to_s(:time),
        attendance.finished_at.to_s,
        attendance.note
      ]
      csv << column_values
    else
      column_values = [
        attendance.worked_on.to_s(:date),
        attendance.started_at,
        attendance.finished_at,
        attendance.note
      ]
      csv << column_values
    end
  end
end