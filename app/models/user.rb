class User < ApplicationRecord
  require 'csv'
  has_many :attendances, dependent: :destroy
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :affiliation, length: { in: 3..50 }, allow_blank: true
  
  def self.search(search) #ここでのself.はUser.を意味する
    if search
      where(['name LIKE ?', "%#{search}%"]) #検索とnameの部分一致を表示。User.は省略
    else
      all #全て表示。User.は省略
    end
  end
  
  def self.import(file)
    ActiveRecord::Base.transaction do
      CSV.foreach(file.path, headers: true, skip_lines: /^(?:,\s*)+$/) do |row|
        # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
        user = find_by(id: row["id"]) || new
        # CSVからデータを取得し、設定する
        user.attributes = row.to_hash.slice(*updatable_attributes)
        # 保存する
        user.save!
      end
    end
  end

  # 更新を許可するカラムを定義
  def self.updatable_attributes
    ["id", "name", "email", "affiliation", "employee_number", "uid", "basic_work_time", "designated_work_start_time", "designated_work_end_time", "superior", "admin", "password"]
  end

end