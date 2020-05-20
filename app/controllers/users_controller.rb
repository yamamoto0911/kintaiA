class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy, :edit_basic_info, :update_basic_info, :index, :attendance_users]
  before_action :ensure_correct_user, only: [:show]
  
  def index
    @users = User.where.not(admin: true).paginate(page: params[:page]).search(params[:search])
  end
  
  def import
    # fileはtmpに自動で一時保存される
    if params[:file].blank?
      flash[:danger] = "インポートするCSVファイルを選択してください。"
      redirect_to users_url
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = "ＣＳＶファイルのみインポートが可能です。"
      redirect_to users_url      
    else
      User.import(params[:file])
      flash[:success] = "CSVファイルをインポートしました。"
      redirect_to users_url
    end
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "データに不備があります。"
      redirect_to users_url
    
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_path if current_user.admin? && @user.admin?
    @first_day = first_day(params[:first_day])
    @last_day = @first_day.end_of_month
    (@first_day..@last_day).each do |day|
      unless @user.attendances.any? {|attendance| attendance.worked_on == day}
        record = @user.attendances.build(worked_on: day)
        record.save
      end
    end
    @dates = user_attendances_month_date
    @worked_sum = @dates.where.not(started_at: nil).count
    @user.employee_number = @user.id
    @over_approval_number = Attendance.where(overwork_superior_id: @user.id).where(overwork_enum: 1).size
    @change_approval_number = Attendance.where(change_superior_id: @user.id).where(change_enum: 1).size
    @month_approval_number = Attendance.where(month_superior_id: @user.id).where(month_enum: 1).size
    respond_to do |format|
      format.html do
      end 
      format.csv do
        send_data render_to_string, filename: "#{@user.name}.csv", type: :csv
      end
    end
  end

  

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "ユーザーの新規作成に成功しました。"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "削除しました。"
    redirect_to users_url
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to users_url
    else
      flash[:danger] = "ユーザー情報の更新に失敗しました。"
      redirect_to users_url
    end
  end
  
  def edit_basic_info
    @user = User.find(params[:id])
  end

  def update_basic_info
    @user = User.find(params[:id])
    if @user.update_attributes(basic_info_params)
      flash[:success] = "基本情報を更新しました。"
      redirect_to @user
    else
      render 'edit_basic_info'
    end
  end
  
  def attendance_users
    @users = User.all.includes(:attendances)
  end
  
  def edit_overwork_request_approval
    @attendances = Attendance.where(overwork_superior_id: current_user.id).where(overwork_enum: 1)
    @users = User.joins(:attendances).group(:name).where(attendances: {overwork_superior_id: current_user.id}).where(attendances: {overwork_enum: 1})
    @user = User.find(params[:id])
    @first_day = first_day(params[:date])
  end
  
  def update_overwork_request_approval
    @user = User.find(params[:id])
    @array = []
    @first_day = first_day(params[:date])
    overwork_approval_params.each do |id, item|
      attendance = Attendance.find(id)
      if item[:overwork_request_change] == "true"
        attendance.update_attributes(item)
      end
      @array.push(item[:overwork_request_change])
    end
    if @array.include?("true")
      flash[:success] = '残業申請を処理しました。'
      redirect_to user_url(@user, params:{first_day: @first_day})
    else
      flash[:danger] = '残業申請処理に失敗しました。'
      redirect_to user_url(@user, params:{first_day: @first_day})
    end
  end
  
  def edit_change_request_approval
    @attendances = Attendance.where(change_superior_id: current_user.id).where(change_enum: 1)
    @users = User.joins(:attendances).group(:name).where(attendances: {change_superior_id: current_user.id}).where(attendances: {change_enum: 1})
    @user = User.find(params[:id])
  end
  
  def update_change_request_approval
    @user = User.find(params[:id])
    @array = []
    @first_day = first_day(params[:date])
    change_approval_params.each do |id, item|
      attendance = Attendance.find(id)
      if item[:change_request_change] == "true"
        attendance.update_attributes(item)
      end
      @array.push(item[:change_request_change])
    end
    if @array.include?("true")
      flash[:success] = '勤怠変更申請を処理しました。'
      redirect_to user_url(@user, params:{first_day: @first_day})
    else
      flash[:danger] = '勤怠変更申請処理に失敗しました。'
      redirect_to user_url(@user, params:{first_day: @first_day})
    end
  end
  
  def edit_month_request_approval
    @attendances = Attendance.where(month_superior_id: current_user.id).where(month_enum: 1)
    @users = User.joins(:attendances).group(:name).where(attendances: {month_superior_id: current_user.id}).where(attendances: {month_enum: 1})
    @user = User.find(params[:id])
  end
  
  def update_month_request_approval
    @user = User.find(params[:id])
    @array = []
    @first_day = first_day(params[:date])
    month_approval_params.each do |id, item|
      attendance = Attendance.find(id)
      if item[:month_request_change] == "true"
        attendance.update_attributes(item)
      end
      @array.push(item[:month_request_change])
    end
    if @array.include?("true")
      flash[:success] = '1ヶ月分勤怠申請を処理しました。'
      redirect_to user_url(@user, params:{first_day: @first_day})
    else
      flash[:danger] = '1ヶ月分勤怠申請処理に失敗しました。'
      redirect_to user_url(@user, params:{first_day: @first_day})
    end
  end
  
  def working_log
    @user = User.find(params[:id])
    @first_day = first_day(params[:first_day])
    @last_day = @first_day.end_of_month
    @records = Attendance.where(user_id: @user.id).where(change_enum: 2).where(worked_on: (@first_day)..(@last_day))
  end
  
  private
    
    def basic_info_params
      params.require(:user).permit(:basic_work_time, :work_time)
    end
  
    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation, :basic_work_time, :work_time, :employee_number, :designated_work_start_time, :designated_work_end_time, :uid )
    end

    def overwork_approval_params
      params.permit(attendances: [:overwork_enum, :overwork_request_change])[:attendances]
    end
    
    def change_approval_params
      params.permit(attendances: [:change_enum, :change_request_change, :change_approval_date])[:attendances]
    end
    
    def month_approval_params
      params.permit(attendances: [:month_enum, :month_request_change])[:attendances]
    end
    
    # beforeアクション

    # ログイン済みユーザーか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) || current_user.admin?
    end
    
    def admin_user
      redirect_to(current_user) unless current_user.admin?
    end
    
    def superior_user
      redirect_to(current_user) unless current_user.superior?
    end
    
    def ensure_correct_user
      if current_user.id != params[:id].to_i && !current_user.admin? && !current_user.superior?
        flash[:danger] = "そのアクセスはできません。"
        redirect_to current_user
      end
    end
end