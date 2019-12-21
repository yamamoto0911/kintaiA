class Attendance < ApplicationRecord
  belongs_to :user
  validates :worked_on, presence: true
  validate :finished_at_edit_valid
  validate :finished_at_edit_valid_compare
  
  enum overwork_enum: { "なし" => 0, "申請中" => 1, "承認" => 2, "否認" => 3 }, _prefix: true
  enum change_enum: { "なし" => 0, "申請中" => 1, "承認" => 2, "否認" => 3 }, _prefix: true

  def finished_at_edit_valid
    if started_at.nil? && finished_at.present?
      errors.add(:finished_at, ": 出社時間が入力されていません。")
    end
  end
  
  def finished_at_edit_valid_compare
    if started_at.present? && finished_at.present? && started_at > finished_at
      errors.add(:finished_at, ": 退社時間が出社時間より早いです。")
    end
  end
  
end
