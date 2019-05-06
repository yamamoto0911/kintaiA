class Attendance < ApplicationRecord
  belongs_to :user
  validates :worked_on, presence: true
  validate :finished_at_edit_valid
  validate :finished_at_edit_valid_compare

  def finished_at_edit_valid
    if started_at == nil
      errors.add(:finished_at, ": 出社時間が入力されていません。")
    end
  end
  
  def finished_at_edit_valid_compare
    if started_at.present? && finished_at.present? && started_at > finished_at
      errors.add(:finished_at, ": 退社時間が出社時間より早いです。")
    end
  end
  
end
